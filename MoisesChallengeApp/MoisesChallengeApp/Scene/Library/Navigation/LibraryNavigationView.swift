//
//  LibraryNavigationView.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import MCDependencyContainer
import MCDesignSystem
import SwiftUI

enum LibraryNavigationPath: Hashable {
    case player([Song])
    case album(String)
}

struct LibraryNavigationView: View {
    @State private var path: [LibraryNavigationPath] = []
    @State private var songMenu: Song?

    var body: some View {
        NavigationStack(path: $path) {
            SongsView {
                path.append(.player($0))
            } onTapMenu: {
                songMenu = $0
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationTitle("Songs")
            .navigationDestination(
                for: LibraryNavigationPath.self
            ) { destination in
                switch destination {
                case .player(let songs):
                    SongPlayerView(songs: songs) {
                        songMenu = $0
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(
                        songs.first?.collectionName 
                        ?? songs.first?.artistName
                        ?? "Player"
                    )
                case .album(let collectionId):
                    AlbumView(collectionId: collectionId) {
                        path = [.player($0)]
                    }
                }
            }
        }
        .sheet(item: $songMenu) { song in
            MenuView(song: song) {
                path.append(.album($0.collectionId ?? ""))
                songMenu = nil
            }
            .presentationDetents([.height(150)])
            .padding(6.ds.quants)
        }
    }
}

#Preview {
    withDependency(
        type: NetworkLibraryRepository.self,
        dependency: LibraryRepositoryMock()
    ) {
        LibraryNavigationView()
    }
}
