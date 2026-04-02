//
//  ToastState.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 31/03/26.
//

import SwiftUI

public struct Toast: Equatable {
    public var type: ToastType
    public var title: String
    public var message: String
    public var duration = 3.0
    public var width: Double = .infinity

    public init(
        type: ToastType,
        title: String,
        message: String,
        duration: Double = 3,) {
            self.type = type
            self.title = title
            self.message = message
            self.duration = duration
        }
}
