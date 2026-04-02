//
//  AlbumViewModel.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 31/03/26.
//

import Foundation

import SwiftUI
import MCDependencyContainer

@MainActor @Observable
class AlbumViewModel {
    @ObservationIgnored @Dependencies private var networkLibraryRepository: NetworkLibraryRepository

    private let collectionId: String
    private let onTapSong: ([Song]) -> Void

    var viewState: ViewState<Album> = .loading

    init(collectionId: String, onTapSong: @escaping ([Song]) -> Void) {
        self.collectionId = collectionId
        self.onTapSong = onTapSong
    }

    func fetchAlbum() async {
        viewState = .loading
        
        do {
            let response = try await networkLibraryRepository.getAlbum(collectonId: collectionId)
            var results: [LibraryItem] = response.results
            let colectionIndex = results.firstIndex(where: { $0.wrapperType == .collection })
            
            guard let colectionIndex else {
                viewState = .empty
                return
            }

            let collection: LibraryItem = results.remove(at: colectionIndex)

            let album = Album(
                name: collection.collectionName,
                artistName: collection.artistName,
                artwork: Artwork(
                    url30: collection.artworkUrl30,
                    url60: collection.artworkUrl60,
                    url100: collection.artworkUrl100
                ),
                songs: results.compactMap { Song(item: $0) }
            )

            viewState = .content(album)
        } catch {
            viewState = .error(error)
        }
    }

    func selectSong(_ selectedSong: Song) {
        let albumSongs = viewState.contentValue?.songs

        var songs = [selectedSong]

        songs.append(contentsOf: albumSongs?.filter { $0 != selectedSong } ?? [])
        onTapSong(songs)
    }
}
