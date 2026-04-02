//
//  View+Toast.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 31/03/26.
//

import SwiftUI

extension View {
    public func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastViewModifier(toast: toast))
    }
}
