//
//  ToastView.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 31/03/26.
//

import SwiftUI

public struct ToastView: View {
    public var toast: Toast
    public var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: 1.ds.quants) {
                if !toast.title.isEmpty {
                    Text(toast.title)
                        .typography(.ds.title2)
                }

                Text(toast.message)
                    .typography(.ds.subtitle2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 6.ds.quants)
        .padding(.vertical, 4.ds.quants)
        .frame(maxWidth: .infinity)
        .background(toast.type.themeColor)
        .clipShape(RoundedRectangle(cornerRadius: 1.ds.quants))
    }
}

#Preview {
    Color.yellow
        .toastView(toast: .constant(Toast(type: .destructive,
                                          title: "No internet connection testing",
                                          message: "Message")))
}
