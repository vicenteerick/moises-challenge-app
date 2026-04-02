//
//  Music.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation

struct LibraryResponse: Decodable {
    let resultCount: Int
    let results: [LibraryItem]
}

struct LibraryItem: Decodable {
    let wrapperType: WrapperType?
    let kind: String?

    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?

    let artistName: String
    let collectionName: String?
    let trackName: String?

    let collectionCensoredName: String?

    let artistViewUrl: URL?
    let collectionViewUrl: URL?

    let previewUrl: URL?

    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?

    let collectionPrice: Double?
    let trackPrice: Double?

    let releaseDate: String?

    let collectionExplicitness: String?
    let trackExplicitness: String?

    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?

    let trackTimeMillis: Int?

    let country: String
    let currency: String
    let primaryGenreName: String

    let isStreamable: Bool?

    let collectionArtistId: Int?
    let collectionArtistName: String?
    let collectionArtistViewUrl: URL?
}


enum WrapperType: String, Decodable {
    case collection
    case track
}
