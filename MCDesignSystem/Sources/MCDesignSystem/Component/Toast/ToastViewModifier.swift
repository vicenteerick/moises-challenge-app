//
//  ToastViewModifier.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 31/03/26.
//

import SwiftUI

public struct ToastViewModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var task: Task<Void, Never>?
    @State private var draggedOffset = CGSize.zero

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    if let toast = toast {
                        VStack(spacing: .zero) {
                            Spacer()

                            ToastView(toast: toast)
                                .padding(.bottom, 2.ds.quants)
                                .padding(.horizontal, 2.ds.quants)
                        }
                        .offset(CGSize(
                            width: draggedOffset.width != 0 ? draggedOffset.width : 0,
                            height: 0
                        ))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    task?.cancel()
                                    draggedOffset = value.translation
                                }
                                .onEnded { value in
                                    if value.translation.width.magnitude > 16.ds.quants {
                                        dismissToast()
                                    } else {
                                        withAnimation(.spring) {
                                            draggedOffset = .zero
                                        }
                                        runTimer()
                                    }
                                }
                        )
                    }
                }
                .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { showToast() }
    }

    private func showToast() {
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        runTimer()
    }

    private func runTimer() {
        guard let toast = toast, toast.duration > 0 else { return }

        task?.cancel()

        task = Task {
            try? await Task.sleep(for: .seconds(toast.duration))

            guard !Task.isCancelled else { return }

            await MainActor.run {
                dismissToast()
            }
        }
    }

    private func dismissToast() {
        withAnimation(.snappy) {
            draggedOffset = .zero
            toast = nil
        }

        task?.cancel()
        task = nil
    }
}
