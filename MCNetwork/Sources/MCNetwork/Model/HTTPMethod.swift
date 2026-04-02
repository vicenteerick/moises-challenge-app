//
//  HTTPMethod.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Hashable, Sendable {
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
