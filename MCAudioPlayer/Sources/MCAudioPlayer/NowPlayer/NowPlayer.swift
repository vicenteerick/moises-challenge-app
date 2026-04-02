//
//  NowPlayer.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 01/04/26.
//

import Foundation
import MediaPlayer
import UIKit

public protocol NowPlayable: Sendable {
    func setPlayerItemMetadata(_ metadata: PlayerItemMetadata, artwork: MPMediaItemArtwork?)
    func setPlaybackMetadata(_ metadata: PlaybackMetadata)
    func loadArtwork(from url: URL?) async -> MPMediaItemArtwork?
}

public struct NowPlayer: NowPlayable {

    public  init() { }

    public func setPlayerItemMetadata(_ metadata: PlayerItemMetadata, artwork: MPMediaItemArtwork?) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = metadata.mediaType.rawValue
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
        nowPlayingInfo[MPNowPlayingInfoCollectionIdentifier] = metadata.collectionIdentifier
        nowPlayingInfo[MPMediaItemPropertyPersistentID] = NSNumber(value: metadata.playbackTrackId)
        // TODO: MPMediaItemPropertyArtwork seems not to be working on simulator
        // TODO: Would need to validate on the real device
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    public func setPlaybackMetadata(_ metadata: PlaybackMetadata) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        let newState: MPNowPlayingPlaybackState = metadata.isPlaying ? .playing : .paused
        if nowPlayingInfoCenter.playbackState != newState {
            nowPlayingInfoCenter.playbackState = metadata.isPlaying ? .playing : .paused
        }

        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()

        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    public func loadArtwork(from url: URL?) async -> MPMediaItemArtwork? {
        guard let url else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else { return nil }

            return MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
        } catch {
            return nil
        }
    }

    private func setCommand(_ command: Command, _ handler: @escaping (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) {
        command.addHandler(handler)
    }
}
