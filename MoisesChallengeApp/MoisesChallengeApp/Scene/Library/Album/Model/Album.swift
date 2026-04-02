//
//  Album.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 31/03/26.
//

import Foundation

struct Album: Equatable {
    let name: String?
    let artistName: String?
    let artwork: Artwork
    let songs: [Song]
}
