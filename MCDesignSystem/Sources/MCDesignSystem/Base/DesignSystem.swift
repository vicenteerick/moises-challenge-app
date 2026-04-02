//
//  DesignSystem.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation

public struct DesignSystem<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public protocol DesignSystemCompatible {
    static var ds: DesignSystem<Self>.Type { get }

    var ds: DesignSystem<Self> { get }
}

public extension DesignSystemCompatible {
    static var ds: DesignSystem<Self>.Type { DesignSystem<Self>.self }

    var ds: DesignSystem<Self> { DesignSystem(self) }
}
