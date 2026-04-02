//
//  Dependencies.swift
//  MCDependencyContainer
//
//  Created by Erick Vicente on 28/03/26.
//

@propertyWrapper public struct Dependencies<T> {
    public var wrappedValue: T

    public init() {
        self.wrappedValue = DependencyContainer.shared.resolve()
    }
}
