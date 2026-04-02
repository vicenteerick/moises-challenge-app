//
//  PlaceholderView.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 02/04/26.
//

import SwiftUI

public struct PlaceholderView: View {
    var icon: Image
    var size: CGFloat

    public init(icon: Image, size: CGFloat) {
        self.icon = icon
        self.size = size
    }

    public var body: some View {
        Rectangle()
            .foregroundColor(.ds.grayScale100)
            .frame(width: size, height: size)
            .overlay(alignment: .center) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.4, height: size * 0.4)
                    .foregroundStyle(Color.ds.grayScale200)
            }
    }
}

#Preview {
    PlaceholderView(icon: Icon.ds.musicNote, size: 14.ds.quants)
}
