//
//  LibraryResponse+Mock.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 02/04/26.
//

import Foundation

#if DEBUG

extension LibraryResponse {
    static let mock: LibraryResponse = .init(
        resultCount: 3,
        results: [
            .mockCollection,
            .mockTrack1,
            .mockTrack2
        ]
    )
}

extension LibraryItem {

    static let mockCollection: LibraryItem = .init(
        wrapperType: .collection,
        kind: nil,
        artistId: 115234,
        collectionId: 1440878798,
        trackId: nil,
        artistName: "Weezer",
        collectionName: "Weezer",
        trackName: nil,
        collectionCensoredName: "Weezer",
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/weezer/115234?uo=4"),
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/weezer/1440878798?uo=4"),
        previewUrl: nil,
        artworkUrl30: nil,
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/60x60bb.jpg"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/100x100bb.jpg"),
        collectionPrice: 9.99,
        trackPrice: nil,
        releaseDate: "1994-05-10T07:00:00Z",
        collectionExplicitness: "notExplicit",
        trackExplicitness: nil,
        discCount: nil,
        discNumber: nil,
        trackCount: 10,
        trackNumber: nil,
        trackTimeMillis: nil,
        country: "USA",
        currency: "USD",
        primaryGenreName: "Rock",
        isStreamable: nil,
        collectionArtistId: nil,
        collectionArtistName: nil,
        collectionArtistViewUrl: nil
    )

    static let mockTrack1: LibraryItem = .init(
        wrapperType: .track,
        kind: "song",
        artistId: 115234,
        collectionId: 1440878798,
        trackId: 1440879114,
        artistName: "Weezer",
        collectionName: "Weezer",
        trackName: "My Name Is Jonas",
        collectionCensoredName: "Weezer",
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/weezer/115234?uo=4"),
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/my-name-is-jonas/1440878798?i=1440879114&uo=4"),
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/6c/c8/1f/6cc81f5c-ba30-62b6-4b7c-91be2c54c0f4/mzaf_14013889043456338844.plus.aac.p.m4a"),
        artworkUrl30: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/30x30bb.jpg"),
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/60x60bb.jpg"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/100x100bb.jpg"),
        collectionPrice: 9.99,
        trackPrice: 1.29,
        releaseDate: "1994-05-10T12:00:00Z",
        collectionExplicitness: "notExplicit",
        trackExplicitness: "notExplicit",
        discCount: 1,
        discNumber: 1,
        trackCount: 10,
        trackNumber: 1,
        trackTimeMillis: 203_960,
        country: "USA",
        currency: "USD",
        primaryGenreName: "Pop",
        isStreamable: true,
        collectionArtistId: nil,
        collectionArtistName: nil,
        collectionArtistViewUrl: nil
    )

    static let mockTrack2: LibraryItem = .init(
        wrapperType: .track,
        kind: "song",
        artistId: 115234,
        collectionId: 1440878798,
        trackId: 1440879129,
        artistName: "Weezer",
        collectionName: "Weezer",
        trackName: "No One Else",
        collectionCensoredName: "Weezer",
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/weezer/115234?uo=4"),
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/no-one-else/1440878798?i=1440879129&uo=4"),
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/71/fc/e7/71fce7c6-7a5a-a3ce-cdfb-a1cc56606dd4/mzaf_3334849013759255417.plus.aac.p.m4a"),
        artworkUrl30: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/30x30bb.jpg"),
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/60x60bb.jpg"),
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/d0/16/da/d016da24-577e-b584-3a5a-116efb5ca362/16UMGIM52971.rgb.jpg/100x100bb.jpg"),
        collectionPrice: 9.99,
        trackPrice: 1.29,
        releaseDate: "1994-05-10T12:00:00Z",
        collectionExplicitness: "notExplicit",
        trackExplicitness: "notExplicit",
        discCount: 1,
        discNumber: 1,
        trackCount: 10,
        trackNumber: 2,
        trackTimeMillis: 185_160,
        country: "USA",
        currency: "USD",
        primaryGenreName: "Pop",
        isStreamable: true,
        collectionArtistId: nil,
        collectionArtistName: nil,
        collectionArtistViewUrl: nil
    )
}

#endif
