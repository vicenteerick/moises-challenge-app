//
//  LibraryEndpoint.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation
import MCNetwork

enum LibraryEndpoint: Endpoint {
    case getLibrary(String)
    case getAlbum(String)

    var method: HTTPMethod { .get }

    var path: String {
        switch self {
        case .getLibrary:
            return "/search"
        case .getAlbum:
            return "/lookup"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getLibrary(let searchTerm):
            return [
                URLQueryItem(
                    name: "term",
                    value: searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
                ),
                URLQueryItem(name: "media", value: "music"),
                URLQueryItem(name: "entity", value: "song")
            ]
        case .getAlbum(let collectionId):
            return [
                URLQueryItem(name: "id", value: collectionId),
                URLQueryItem(name: "entity", value: "song")
            ]
        }
    }
}
