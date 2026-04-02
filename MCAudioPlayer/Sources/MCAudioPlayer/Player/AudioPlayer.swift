//
//  AudioPlayer.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 30/03/26.
//

import AVFoundation
import MediaPlayer
import SwiftUI

@MainActor
public  protocol Player: Sendable {
    var currentItem: PlayerItemMetadata? { get }

    func buildPlayer(items: [PlayerItemMetadata]) async
    func play() throws
    func pause()
    func seek(to time: Double) async
    func nextItem()
    func previousItem()
    func playbackProgress() -> AsyncStream<PlaybackProgress>
    func unbuildPlayer()
}

@Observable
public class AudioPlayer: Player {
    @ObservationIgnored
    private var player: AVQueuePlayer?
    @ObservationIgnored
    private var audioSession: AudioSessionConfigurable
    @ObservationIgnored
    private var nowPlayer: NowPlayable
    @ObservationIgnored
    private var playerItems: [PlayerItemMetadata] = []
    @ObservationIgnored
    private var itemObserver: NSKeyValueObservation?

    public var currentItem: PlayerItemMetadata?
    public var duration: Double = 0

    public init(
        audioSession: AudioSessionConfigurable = AudioSessionConfiguration(),
        nowPlayer: NowPlayable = NowPlayer()
    ) {
        self.audioSession = audioSession
        self.nowPlayer = nowPlayer
        setCommands()
    }

    public func buildPlayer(items: [PlayerItemMetadata]) async {
        playerItems = items
        player = AVQueuePlayer(items: items.map { $0.avPlayerItem })
        player?.allowsExternalPlayback = true
        currentItem = items.first
        duration = (try? await player?.currentItem?.asset.load(.duration).seconds) ?? 0
        observeItem()
    }

    public func play() throws {
        try audioSession.configure()

        if round(duration) == round(player?.currentTime().seconds ?? 0) {
            player?.seek(to: .zero)
        }

        player?.play()
    }

    public func pause() {
        player?.pause()
    }

    public func seek(to time: Double) async {
        await player?.seek(
            to: .init(seconds: time, preferredTimescale: 1000),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }

    public func nextItem() {
        guard let player else { return }

        let currentIndex = playerItems.firstIndex { $0 == currentItem } ?? 0
        let nextIndex = currentIndex + 1

        guard nextIndex > 0, nextIndex < playerItems.count else {
            player.seek(to: .init(seconds: duration, preferredTimescale: 1000))
            player.pause()
            return
        }

        player.advanceToNextItem()
        player.seek(to: .zero)

        if PlayerState(from: player.timeControlStatus) == .playing {
            player.play()
        }
    }

    public func previousItem() {
        // TODO: The order should be persisted to gurantee the correct previousItem
        guard let player, let currentItem else { return }

        let currentTime = player.currentTime().seconds
        let currentIndex = playerItems.firstIndex { $0 == currentItem } ?? 0
        let previousIndex = currentIndex - 1

        guard currentTime < 3, previousIndex > 0, previousIndex < playerItems.count else {
            player.seek(to: .zero)
            return
        }

        player.removeAllItems()

        for item in playerItems[(previousIndex - 1)...] {
            if player.canInsert(item.avPlayerItem, after: nil) {
                player.insert(item.avPlayerItem, after: nil)
            }
        }

        player.seek(to: .zero)

        if PlayerState(from: player.timeControlStatus) == .playing {
            player.play()
        }
    }

    public func playbackProgress() -> AsyncStream<PlaybackProgress> {
        AsyncStream { continuation in
            guard let player = self.player else {
                continuation.finish()
                return
            }

            let duration = self.duration

            let progress = PlaybackProgress(
                currentTime: 0,
                duration: duration,
                rate: player.rate,
                state: PlayerState(from: player.timeControlStatus)
            )

            continuation.yield(progress)

            let observer = player.addPeriodicTimeObserver(
                forInterval: CMTime(value: 1, timescale: 1000),
                queue: .main
            ) { time in
                let progress = PlaybackProgress(
                    currentTime: time.seconds,
                    duration: duration,
                    rate: player.rate,
                    state: PlayerState(from: player.timeControlStatus)
                )

                Task { await self.setPlayback(progress) }
                continuation.yield(progress)
            }

            nonisolated(unsafe) let observerToken = observer

            continuation.onTermination = { @Sendable _ in
                Task { @MainActor in
                    self.player?.removeTimeObserver(observerToken)
                }
            }
        }
    }

    public func unbuildPlayer() {
        player?.pause()
        player?.removeAllItems()

        itemObserver?.invalidate()
        itemObserver = nil

        currentItem = nil
        duration = 0

        player = nil
        try? audioSession.deactivate()

        resetNowPlayer()
    }

    private func observeItem() -> Void {
        itemObserver = player?.observe(
            \.currentItem,
             options: .initial
        ) {
            [unowned self] _, _ in
            Task { await self.setItem() }
        }
    }

    @MainActor
    private func setItem() async {
        guard let player, let item = player.currentItem else { return }
        guard let metadata = playerItems.first(where: { $0.avPlayerItem == item }) else { return }

        currentItem = metadata
        duration = (try? await item.asset.load(.duration).seconds) ?? 0

        let artworkURL = metadata.artworkURL

        let artwork = await nowPlayer.loadArtwork(from: artworkURL)

        nowPlayer.setPlayerItemMetadata(metadata, artwork: artwork)
        setPlayback(
            PlaybackProgress(
                currentTime: 0.0,
                duration: duration,
                rate: player.rate,
                state: PlayerState(from: player.timeControlStatus)
            )
        )
    }

    @MainActor
    private func setPlayback(_ progress: PlaybackProgress) {
        nowPlayer.setPlaybackMetadata(
            .init(
                rate: progress.rate,
                position: Float(progress.currentTime),
                duration: Float(progress.duration),
                isPlaying: progress.state == .playing
            )
        )

        if progress.state == .paused {
            try? audioSession.deactivate()
        }
    }

    private func resetNowPlayer() {
        nowPlayer.setPlayerItemMetadata(
            PlayerItemMetadata(
                assetURL: URL(fileURLWithPath: ""),
                title: "",
                artist: nil,
                artworkURL: nil,
                albumArtist: nil,
                albumTitle: nil,
                collectionIdentifier: nil,
                playbackTrackId: 0
            ),
            artwork: nil
        )

        nowPlayer.setPlaybackMetadata(
            PlaybackMetadata(rate: 0, position: 0, duration: 0, isPlaying: false)
        )
    }

    private func setCommands() {
        Command.play.addHandler { [weak self] _ in
            try? self?.play()
            return .success
        }

        Command.pause.addHandler { [weak self] _ in
            self?.pause()
            return .success
        }

        Command.changePlaybackPosition.addHandler { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.player?.seek(
                to: .init(seconds: event.positionTime, preferredTimescale: 1000)
            )
            return .success
        }

        Command.nextTrack.addHandler { [weak self] _ in
            self?.nextItem()
            return .success
        }

        Command.previousTrack.addHandler { [weak self] _ in
            self?.previousItem()
            return .success
        }
    }
}

