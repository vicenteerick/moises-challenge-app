//
//  PlayerItemMetadata.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 01/04/26.
//

import MediaPlayer

public struct PlayerItemMetadata: Equatable {
    public let assetURL: URL
    let mediaType: MPNowPlayingInfoMediaType = .audio

    let isLiveStream: Bool = false

    let title: String
    let artist: String?
    let artworkURL: URL?

    let albumArtist: String?
    let albumTitle: String?
    let collectionIdentifier: String?
    /// Published as `MPMediaItemPropertyPersistentID` for Now Playing / CarPlay row matching.
    let playbackTrackId: Int
    let avPlayerItem: AVPlayerItem

    public init(
        assetURL: URL,
        title: String,
        artist: String?,
        artworkURL: URL?,
        albumArtist: String?,
        albumTitle: String?,
        collectionIdentifier: String?,
        playbackTrackId: Int
    ) {
        self.assetURL = assetURL
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.albumArtist = albumArtist
        self.albumTitle = albumTitle
        self.collectionIdentifier = collectionIdentifier
        self.playbackTrackId = playbackTrackId
        self.avPlayerItem = AVPlayerItem(url: assetURL)
    }
}
