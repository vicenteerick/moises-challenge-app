//
//  ToastType.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 31/03/26.
//

import Foundation
import SwiftUI

public enum ToastType {
    case success
    case destructive

    var themeColor: Color {
        switch self {
        case .destructive:
            return Color.ds.backgroundComplementary
        case .success:
            return Color.ds.backgroundPrimary
        }
    }
}
