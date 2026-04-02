//
//  SongsView.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import MCDependencyContainer
import MCDesignSystem
import SwiftUI

struct SongsView: View {
    private var viewModel = SongsViewModel()
    private let imageSize: CGFloat = 14.ds.quants
    
    @State private var search: String = ""

    var onTapSong: ([Song]) -> Void
    var onTapMenu: (Song) -> Void

    init(
        onTapSong: @escaping ([Song]) -> Void,
        onTapMenu: @escaping (Song) -> Void
    ) {
        self.onTapSong = onTapSong
        self.onTapMenu = onTapMenu
    }

    var body: some View {
        VStack(spacing: .zero) {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .error:
                EdgeCaseView(
                    icon: Icon.ds.warning,
                    title: "Fail to Load",
                    description: "Try a new search"
                )
            case .empty:
                EdgeCaseView(
                    icon: Icon.ds.musicNoteTone,
                    title: "No Data found",
                    description: "Search for a song"
                )
            case .content(let items):
                ScrollView {
                    LazyVStack(spacing: .zero) {
                        ForEach(items, id: \.id) { item in
                            HStack(spacing: .zero) {
                                AsyncImage(url: item.artwork.url60) { image in
                                    image
                                        .resizable()
                                        .frame(width: imageSize, height: imageSize)
                                } placeholder: {
                                    PlaceholderView(
                                        icon: Icon.ds.musicNote,
                                        size: imageSize
                                    )
                                }
                                .cornerRadius(2.ds.quants)

                                VStack(alignment: .leading, spacing: 1.ds.quants) {
                                    Text(item.artistName)
                                        .typography(.ds.title2)

                                    Text(item.trackName)
                                        .typography(.ds.subtitle1, color: .ds.textGrayScale200)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 4.ds.quants)

                                Button(action: { onTapMenu(item) }) {
                                    Icon.ds.more
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 3.ds.quants, height: 3.ds.quants)
                                        .foregroundStyle(Color.ds.textGrayScale200)
                                        .padding(6.ds.quants)
                                }
                            }
                            .padding(.horizontal, 6.ds.quants)
                            .padding(.vertical, 2.ds.quants)
                            .contentShape(Rectangle())
                            .onTapGesture { onTapSong([item]) }
                        }
                    }
                    .padding(.vertical, 2.ds.quants)
                }
            }
        }
        .searchable(text: $search)
        .onChange(
            of: search,
            debounceTime: .milliseconds(500)
        ) { searchTerm in
            Task {
                await viewModel.fetchSongs(searchTerm: searchTerm)
            }
        }
    }
}

#Preview {
    withDependency(
        type: NetworkLibraryRepository.self,
        dependency: LibraryRepositoryMock()
    ) {
        NavigationStack {
            SongsView(onTapSong: { _ in }, onTapMenu: { _ in })
        }
        .navigationTitle("Songs")
    }
}
