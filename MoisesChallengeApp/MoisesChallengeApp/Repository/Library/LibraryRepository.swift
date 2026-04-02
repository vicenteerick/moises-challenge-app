//
//  LibraryRepository.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation

protocol NetworkLibraryRepository {
    func search(term: String) async throws -> LibraryResponse
    func getAlbum(collectonId: String) async throws -> LibraryResponse
}
