//
//  SongPlayerView.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 30/03/26.
//

import MCAudioPlayer
import MCDependencyContainer
import MCDesignSystem
import SwiftUI

struct SongPlayerView: View {
    @Bindable private var viewModel: SongPlayerViewModel

    private let imageSize: CGFloat = 66.ds.quants
    private let playIconSize: CGFloat = 5.ds.quants
    private let controlIconSize: CGFloat = 4.ds.quants
    private var onTapMenu: (Song) -> Void

    init(
        songs: [Song],
        onTapMenu: @escaping (Song) -> Void
    ) {
        self.viewModel = SongPlayerViewModel(songs: songs)
        self.onTapMenu = onTapMenu
    }

    var body: some View {
        VStack(spacing: .zero) {
            AsyncImage(url: viewModel.currentSongs?.artwork.url300) { image in
                image
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
            } placeholder: {
                PlaceholderView(
                    icon: Icon.ds.musicNote,
                    size: imageSize
                )
            }
            .cornerRadius(8.ds.quants)
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 6.ds.quants)
            .onTapGesture {
                if let currentSongs = viewModel.currentSongs {
                    onTapMenu(currentSongs)
                }
            }

            Text(viewModel.currentSongs?.trackName ?? "")
                .typography(.ds.heading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 3.ds.quants)
                .padding(.horizontal, 6.ds.quants)

            Text(viewModel.currentSongs?.artistName ?? "")
                .typography(.ds.title1, color: .ds.textGrayScale100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 6.ds.quants)

            DraggableSliderView(
                value: $viewModel.currentTime,
                maximum: viewModel.duration,
                onEditingChanged: { isEditing in
                    Task { await viewModel.seek(isEditing: isEditing) }
                }
            )
            .padding(.top, 5.ds.quants)
            .padding(.horizontal, 6.ds.quants)

            HStack(spacing: .zero) {
                Text(viewModel.currentTimeLabel)
                    .typography(.ds.subtitle1, color: .ds.textGrayScale100)

                Spacer()

                Text(viewModel.durationLabel)
                    .typography(.ds.subtitle1, color: .ds.textGrayScale100)
            }
            .padding(.horizontal, 6.ds.quants)

            HStack(spacing: 8.ds.quants) {
                Button(action: viewModel.previousItem) {
                    Icon.ds.previous
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: controlIconSize, height: controlIconSize)
                        .foregroundStyle(Color.ds.backgroundBaseContrast)
                        .padding(2.ds.quants)
                }
                
                Button(action: viewModel.playPause) {
                    (viewModel.isPlaying ? Icon.ds.pause : Icon.ds.play)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: playIconSize, height: playIconSize)
                        .foregroundStyle(Color.ds.backgroundBaseContrast)
                        .padding(6.ds.quants)
                }
                .glassEffect(.regular, in: .circle)

                Button(action: viewModel.nextItem) {
                    Icon.ds.next
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: controlIconSize, height: controlIconSize)
                        .foregroundStyle(Color.ds.backgroundBaseContrast)
                        .padding(2.ds.quants)
                }
            }
            .padding(.top, 5.ds.quants)
            .padding(.horizontal, 6.ds.quants)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom
        )
        .task { await viewModel.setup() }
        .onDisappear(perform: viewModel.onDisappear)
        .toastView(toast: $viewModel.toast)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if let currentSongs = viewModel.currentSongs {
                        onTapMenu(currentSongs)
                    }
                } label: {
                    Icon.ds.more
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: controlIconSize, height: controlIconSize)
                        .foregroundStyle(Color.ds.backgroundBaseContrast)
                        .padding(2.ds.quants)
                }
            }
        }
    }
}

#Preview {
    withDependency(type: Player.self, dependency: PlayerMock()) {
        let mock = Song.mock

        return NavigationStack {
            SongPlayerView(
                songs: [mock],
                onTapMenu: { _ in }
            )
        }
        .navigationTitle(mock.collectionName ?? mock.artistName)
    }
}
