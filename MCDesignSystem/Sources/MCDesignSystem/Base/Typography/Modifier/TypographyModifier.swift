//
//  TypographyModifier.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 28/03/26.
//

import SwiftUI

public struct TypographyModifier: ViewModifier {
    var descriptor: TypographyDescriptor
    var color: Color

    public init(descriptor: TypographyDescriptor, color: Color) {
        self.descriptor = descriptor
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .font(descriptor.font)
            .foregroundColor(color)
    }
}

public extension View {
    func typography(
        _ typographyDescriptor: TypographyDescriptor,
        color: Color = .ds.textBase
    ) -> some View {
        modifier(
            TypographyModifier(
                descriptor: typographyDescriptor,
                color: color
            )
        )
    }
}

public extension Text {
    @MainActor
    func typography(
        _ typographyDescriptor: TypographyDescriptor,
        color: Color = .ds.textBase
    ) -> some View {
        modifier(
            TypographyModifier(
                descriptor: typographyDescriptor,
                color: color
            )
        )
    }
}
