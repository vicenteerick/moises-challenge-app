//
//  LibraryRepositoryMock.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 02/04/26.
//

import Foundation
import MCNetwork

#if DEBUG
struct LibraryRepositoryMock: NetworkLibraryRepository {

    enum LibraryErrorMock: Error {
        case failed
    }

    private let error: LibraryErrorMock?
    private let getAlbumResponse: LibraryResponse?

    init(error: LibraryErrorMock? = nil, getAlbumResponse: LibraryResponse? = nil) {
        self.error = error
        self.getAlbumResponse = getAlbumResponse
    }

    func search(term: String) async throws -> LibraryResponse {
        if let error {
            throw error
        }

        return term.isEmpty ? LibraryResponse(resultCount: 0, results: []) :.mock
    }
    
    func getAlbum(collectonId: String) async throws -> LibraryResponse {
        if let error {
            throw error
        }

        return getAlbumResponse ?? .mock
    }
}
#endif
