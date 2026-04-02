//
//  Song.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation

struct Song: Hashable, Identifiable {
    let id: Int
    let artistName: String
    let trackName: String
    let artwork: Artwork
    let previewUrl: URL
    let collectionName: String?
    let collectionArtistName: String?
    let collectionId: String?

    init?(item: LibraryItem) {
        // TODO: Log when item is not nil
        guard item.wrapperType == .track,
              let trackId = item.trackId,
              let trackName = item.trackName,
              let previewUrl = item.previewUrl else { return nil }

        self.id = trackId
        self.artistName = item.artistName
        self.trackName = trackName
        self.artwork = Artwork(
            url30: item.artworkUrl30,
            url60: item.artworkUrl60,
            url100: item.artworkUrl100
        )
        self.previewUrl = previewUrl
        self.collectionName = item.collectionName
        self.collectionArtistName = item.collectionArtistName

        if let collectionIdInt = item.collectionId {
            self.collectionId = "\(collectionIdInt)"
        } else {
            self.collectionId = nil
        }
    }
}

#if DEBUG

extension Song {
    static let mock: Song = {
        guard let song = Song(item: .mockTrack1) else {
            fatalError("Failed to create Song mock from LibraryItem.mockTrack1")
        }
        return song
    }()

    static let mock2: Song = {
        guard let song = Song(item: .mockTrack2) else {
            fatalError("Failed to create Song mock from LibraryItem.mockTrack2")
        }
        return song
    }()
}

#endif
