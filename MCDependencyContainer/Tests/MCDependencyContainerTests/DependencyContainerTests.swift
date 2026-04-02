//
//  DependencyContainerTests.swift
//  MCDependencyContainer
//
//  Created by Erick Vicente on 28/03/26.
//

import Testing
@testable import MCDependencyContainer

struct DependencyContainerTests {

    @Test
    func registerSharedDependency_whenResolved_shouldReturnSameInstance() {
        let container = DependencyContainer()

        container.register(
            type: Service.self,
            dependency: TestService(),
            mode: .sharedInstance
        )

        let resolved1: Service = container.resolve()
        let resolved2: Service = container.resolve()

        #expect((resolved1 is TestService))
        #expect((resolved2 is TestService))
        #expect((resolved1 as? TestService)  === (resolved2 as? TestService))
    }

    @Test
    func registerNewDependency_whenResolved_shouldReturnNewInstances() {
        let container = DependencyContainer()

        container.register(
            type: Service.self,
            dependency: TestService(),
            mode: .newInstance
        )

        let resolved1: Service = container.resolve()
        let resolved2: Service = container.resolve()

        #expect((resolved1 is TestService))
        #expect((resolved2 is TestService))
        #expect((resolved1 as? TestService)  !== (resolved2 as? TestService))
    }

}

private protocol Service { }
private final class TestService: Service { }

