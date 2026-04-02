//
//  AlbumView.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 31/03/26.
//

import MCDependencyContainer
import MCDesignSystem
import SwiftUI

struct AlbumView: View {
    private var viewModel: AlbumViewModel
    private let albumImageSize: CGFloat = 120
    private let musicImageSize: CGFloat = 44

    init(
        collectionId: String,
        onTapSong: @escaping ([Song]) -> Void
    ) {
        self.viewModel = AlbumViewModel(collectionId: collectionId, onTapSong: onTapSong)
    }

    var body: some View {
        VStack(spacing: .zero) {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .error:
                Icon.ds.warning
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.ds.quants, height: 20.ds.quants)
                    .foregroundStyle(Color.ds.grayScale100)
                
                Text("Load Failed")
                    .typography(.ds.heading, color: .ds.textGrayScale100)
                    .padding(.top, 5.ds.quants)

                Button(action: { Task { await viewModel.fetchAlbum() } }) {
                    Text("Try again")
                        .typography(.ds.title1, color: .ds.backgroundPrimary)
                        .padding(2.ds.quants)
                }
                .padding(.top, 4.ds.quants)
            case .empty:
                EdgeCaseView(
                    icon: Icon.ds.musicNoteTone,
                    title: "No Data found",
                    description: "Try again or try another album"
                )
            case .content(let item):
                VStack(alignment: .center, spacing: .zero) {
                    AsyncImage(url: item.artwork.url300 ?? item.artwork.url100) { image in
                        image
                            .resizable()
                            .frame(width: albumImageSize, height: albumImageSize)
                    } placeholder: {
                        PlaceholderView(
                            icon: Icon.ds.musicNote,
                            size: albumImageSize
                        )
                    }
                    .cornerRadius(5.ds.quants)

                    VStack(alignment: .center, spacing: 1.ds.quants) {
                        Text(item.name ?? "")
                            .typography(.ds.title1)

                        Text(item.artistName ?? "")
                            .typography(.ds.title2)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4.ds.quants)
                }
                .padding(.horizontal, 5.ds.quants)

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: .zero) {
                        ForEach(item.songs, id: \.id) { song in
                            HStack(spacing: 4.ds.quants) {
                                AsyncImage(url: item.artwork.url300 ?? item.artwork.url100) { image in
                                    image
                                        .resizable()
                                        .frame(width: musicImageSize, height: musicImageSize)
                                } placeholder: {
                                    PlaceholderView(
                                        icon: Icon.ds.musicNote,
                                        size: musicImageSize
                                    )
                                }
                                .cornerRadius(2.ds.quants)

                                VStack(alignment: .leading, spacing: 1.ds.quants) {
                                    Text(song.artistName)
                                        .typography(.ds.title2)

                                    Text(song.trackName)
                                        .typography(.ds.subtitle2, color: .ds.textGrayScale200)

                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top, 2.ds.quants)
                            .contentShape(Rectangle())
                            .onTapGesture { viewModel.selectSong(song) }
                        }
                    }
                    .padding(.top, 12.ds.quants)
                    .padding(.bottom, 2.ds.quants)
                }
                .padding(.horizontal, 5.ds.quants)
            }
        }
        .task { await viewModel.fetchAlbum() }
    }
}

#Preview {
    withDependency(
        type: NetworkLibraryRepository.self,
        dependency: LibraryRepositoryMock()
    ) {
        AlbumView(collectionId: "", onTapSong: { _ in })
    }
}
