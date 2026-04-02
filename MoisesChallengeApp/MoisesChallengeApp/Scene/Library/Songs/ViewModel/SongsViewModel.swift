//
//  SongsViewModel.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import SwiftUI
import MCDependencyContainer

@MainActor @Observable
class SongsViewModel {
    @ObservationIgnored @Dependencies var networkLibraryRepository: NetworkLibraryRepository
    var viewState: ViewState<[Song]> = .empty

    func fetchSongs(searchTerm: String) async {
        viewState = .loading
        do {
            let response = try await networkLibraryRepository.search(term: searchTerm)

            let songs: [Song] = response.results.compactMap { Song(item: $0) }

            // TODO: Show the last musics listened instead of empty
            viewState = songs.isEmpty ? .empty : .content(songs)
        } catch {
            viewState = .error(error)
        }
    }
}
