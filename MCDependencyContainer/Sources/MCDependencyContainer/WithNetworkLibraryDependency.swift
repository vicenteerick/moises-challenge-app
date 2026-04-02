//
//  WithNetworkLibraryDependency.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 02/03/26.
//

#if DEBUG
public func withDependency<Dependency, T>(
    type: Dependency.Type,
    dependency: Dependency,
    closure: () -> T
) -> T {
    let dependencyContainer = DependencyContainer()
    dependencyContainer.register(type: type, dependency: dependency)

    return DependencyContainer.$shared.withValue(dependencyContainer) {
        closure()
    }
}

public func withDependency<T, Dependency>(
    type: Dependency.Type,
    dependency: Dependency,
    closure: () async throws -> T
) async rethrows -> T {
    let dependencyContainer = DependencyContainer()
    dependencyContainer.register(type: type, dependency: dependency)

    return try await DependencyContainer.$shared.withValue(dependencyContainer) {
        try await closure()
    }
}

// TODO: withDependency Receiving multiple dependencies

#endif
