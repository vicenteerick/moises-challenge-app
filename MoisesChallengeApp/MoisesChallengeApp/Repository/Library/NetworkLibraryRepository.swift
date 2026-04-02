//
//  NetworkLibraryRepository.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation
import MCDependencyContainer
import MCNetwork

final class LibraryRepository: NetworkLibraryRepository {

    @Dependencies private var networkCLient: NetworkClient

    func search(term: String) async throws -> LibraryResponse {
        try await networkCLient.request(setup: LibraryEndpoint.getLibrary(term))
    }

    func getAlbum(collectonId: String) async throws -> LibraryResponse {
        try await networkCLient.request(setup: LibraryEndpoint.getAlbum(collectonId))
    }
}
