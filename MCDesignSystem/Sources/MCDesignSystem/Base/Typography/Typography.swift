//
//  Typography.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 28/03/26.
//

import SwiftUI

@MainActor
public extension DesignSystem where Base == TypographyDescriptor {
    /// fontSize: 32 / fontWeight: semibold
    static let heading = TypographyDescriptor(font: .font(.heading))
    /// fontSize: 20 / fontWeight: semibold
    static let title1 = TypographyDescriptor(font: .font(.title1))
    /// fontSize: 16 / fontWeight: medium
    static let title2 = TypographyDescriptor(font: .font(.title2))
    /// fontSize: 14 / fontWeight: medium
    static let subtitle1 = TypographyDescriptor(font: .font(.subtitle1))
    /// fontSize: 12 / fontWeight: medium
    static let subtitle2 = TypographyDescriptor(font: .font(.subtitle2))
}

private extension Font {
    static func font(_ type: FontType) -> Font {
        .system(size: type.fontSize, weight: type.fontWeight)
    }
}

public enum FontType {
    case heading
    case title1
    case title2
    case subtitle1
    case subtitle2

    var fontSize: CGFloat {
        switch self {
        case .heading: 32
        case .title1: 20
        case .title2: 16
        case .subtitle1: 14
        case .subtitle2: 12
        }
    }

    var fontWeight: Font.Weight {
        switch self {
        case .heading: .semibold
        case .title1: .semibold
        case .title2: .medium
        case .subtitle1: .medium
        case .subtitle2: .medium
        }
    }
}
