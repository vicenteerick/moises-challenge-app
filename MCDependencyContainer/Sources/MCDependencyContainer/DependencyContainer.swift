//
//  DependencyContainer.swift
//  MCDependencyContainer
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation
import OSLog

public final class DependencyContainer: @unchecked Sendable {
    public  enum RegisterMode {
        case newInstance
        case sharedInstance
    }

    private var newInstances = [String: () -> Any]()
    private var sharedInstances = [String: Any]()
    private let logger = Logger(subsystem: "MCDependencyContainer", category: "MCDependencyContainer")

    @TaskLocal
    public static var shared = DependencyContainer()

    public func register<Dependency>(
        type: Dependency.Type,
        dependency: @autoclosure @escaping () -> Dependency,
        mode: RegisterMode = .sharedInstance
    ) {
        guard getInstance(type) == nil else {
            logger.warning("Dependency \(String(reflecting: Dependency.self)) already registered")
            return
        }

        switch mode {
        case .newInstance:
            newInstances[String(reflecting: Dependency.self)] = dependency
        case .sharedInstance:
            sharedInstances[String(reflecting: Dependency.self)] = dependency()
        }

        logger.info("Dependency \(String(reflecting: Dependency.self)) registered as \(mode == .newInstance ? "new" : "shared")")
    }

    public func resolve<Dependency>() -> Dependency {
        guard let dependency = getInstance(Dependency.self) else {
            fatalError("Dependency \(String(reflecting: Dependency.self)) not registered")
        }
        
        return dependency
    }

    private func getInstance<Dependency>(_ dependency: Dependency.Type) -> Dependency? {
        if let newInstance = newInstances[String(reflecting: dependency)] {
            return newInstance() as? Dependency
        }

        if let sharedInstance = sharedInstances[String(reflecting: dependency)] {
            return sharedInstance as? Dependency
        }

        return nil
    }
}
