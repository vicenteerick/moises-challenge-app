//
//  DebouncedChangeViewModifier.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import SwiftUI

public struct DebouncedChangeViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let action: (Value) -> Void
    let sleep: @Sendable () async throws -> Void

    @State private var debouncedTask: Task<Void, Never>?

    public init(
        trigger: Value,
        action: @escaping (Value) -> Void,
        sleep: @Sendable @escaping () async throws -> Void,
        debouncedTask: Task<Void, Never>? = nil
    ) {
        self.trigger = trigger
        self.action = action
        self.sleep = sleep
        self.debouncedTask = debouncedTask
    }

    public func body(content: Content) -> some View {
        content.onChange(of: trigger) { _, value in
            debouncedTask?.cancel()

            debouncedTask = Task {
                do {
                    try await sleep()
                } catch {
                    return
                }

                action(value)
            }
        }
    }
}

extension View {
    func onChange<Value>(
        of value: Value,
        debounceTime: Duration,
        perform action: @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChangeViewModifier(trigger: value, action: action) {
            try await Task.sleep(for: debounceTime)
        })
    }
}
