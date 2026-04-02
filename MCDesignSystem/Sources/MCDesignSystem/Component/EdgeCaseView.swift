//
//  EdgeCaseView.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 02/04/26.
//

import SwiftUI

public struct EdgeCaseView: View {

    private let icon: Image
    private let title: String
    private let description: String

    public init(icon: Image, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    public var body: some View {
        VStack(spacing: .zero) {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20.ds.quants, height: 20.ds.quants)
                .foregroundStyle(Color.ds.grayScale100)

            Text(title)
                .typography(.ds.heading, color: .ds.textGrayScale100)
                .padding(.top, 5.ds.quants)

            Text(description)
                .typography(.ds.title1, color: .ds.textGrayScale200)
        }
    }
}

#Preview {
    EdgeCaseView(
        icon: Icon.ds.musicNoteTone,
        title: "No Data found",
        description: "Search for a song"
    )
}
