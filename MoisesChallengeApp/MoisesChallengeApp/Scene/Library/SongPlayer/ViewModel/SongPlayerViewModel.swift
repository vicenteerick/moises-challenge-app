//
//  SongPlayerViewModel.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 30/03/26.
//

import MCAudioPlayer
import MCDependencyContainer
import MCDesignSystem
import SwiftUI

enum SongPlayerError: Error {
    case noSong
}

@MainActor @Observable
class SongPlayerViewModel {
    @ObservationIgnored @Dependencies var audioPlayer: Player

    private var progressTask: Task<Void, Never>?

    private var isScrubbing: Bool = false
    private var isSeeking: Bool = false

    var songs: [Song]
    var currentSongs: Song?
    var isPlaying: Bool = false
    var currentTime: Double = 0
    var duration: Double = 0
    var durationLabel: String = "00:00"
    var currentTimeLabel: String = "00:00"

    var toast: Toast?

    init(songs: [Song]) {
        self.songs = songs
    }

    func setup() async {
        await buildPlayer()
        await observePlaybackProgress()
    }

    func playPause() {
        if isPlaying {
            audioPlayer.pause()
        } else {
            play()
        }
    }

    func seek(isEditing: Bool) async {
        isScrubbing = isEditing
        if isEditing { return }

        isSeeking = true
        await audioPlayer.seek(to: currentTime)
        isSeeking = false
        
        play()
    }

    func nextItem() {
        audioPlayer.nextItem()
    }

    func previousItem() {
        audioPlayer.previousItem()
    }

    func onDisappear() {
        audioPlayer.unbuildPlayer()
    }

    private func play() {
        do {
            try audioPlayer.play()
        } catch {
            toast = Toast(
                type: .destructive,
                title: "Play Failed",
                message: "Try again or try another song"
            )
        }
    }

    private func buildPlayer() async {
        let itemMetadatas = songs.map { song in
            PlayerItemMetadata(
                assetURL: song.previewUrl,
                title: song.trackName,
                artist: song.artistName,
                artworkURL: song.artwork.url1024 ?? song.artwork.url100,
                albumArtist: song.collectionArtistName,
                albumTitle: song.collectionName,
                collectionIdentifier: song.collectionId,
                playbackTrackId: song.id
            )
        }

        await audioPlayer.buildPlayer(items: itemMetadatas)
    }

    private func observePlaybackProgress() async {
        // TODO: should be able to know disable previous/next
        // TODO: through PlaybackProgress, if there is no previous/next item
        for await progress in audioPlayer.playbackProgress() {
            if !isScrubbing && !isSeeking {
                self.currentTime = progress.currentTime
                self.currentTimeLabel = formatTime(progress.currentTime)
            }

            self.duration = progress.duration
            self.durationLabel = formatTime(progress.duration)
            self.isPlaying = progress.state == .playing
            self.setCurrentSong()
        }
    }

    private func setCurrentSong() {
        currentSongs = songs.first { song in
            song.previewUrl == audioPlayer.currentItem?.assetURL
        }
    }

    func formatTime(_ duration: Double) -> String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
