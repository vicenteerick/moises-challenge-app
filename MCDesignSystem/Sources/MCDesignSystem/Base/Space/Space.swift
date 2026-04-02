//
//  Space.swift
//  MCDesignSystem
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation

public extension DesignSystem where Base == Double {
    var quants: Double { 4 * base }
}

public extension DesignSystem where Base == Int {
    var quants: Int { 4 * base }
}
