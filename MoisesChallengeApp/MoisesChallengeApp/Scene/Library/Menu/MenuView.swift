//
//  MenuView.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 02/04/26.
//

import MCDesignSystem
import SwiftUI

struct MenuView: View {

    var song: Song
    var onTapAlbum: (Song) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Text(song.trackName)
                .typography(.ds.title2)

            Text(song.artistName)
                .typography(.ds.subtitle2)

            Button(action: {
                onTapAlbum(song)
            }) {
                Icon.ds.album
                    .foregroundStyle(Color.ds.backgroundBaseContrast)

                Text("View album")
                    .typography(.ds.subtitle2)
                    .padding(.vertical, 5.ds.quants)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5.ds.quants)
        }
    }
}

#Preview {
    MenuView(song: Song.mock, onTapAlbum: { _ in })
}
