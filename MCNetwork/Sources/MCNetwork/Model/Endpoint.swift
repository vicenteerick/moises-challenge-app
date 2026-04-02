//
//  Endpoint.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

public typealias HTTPHeader = [String: String]

public protocol Endpoint {
    var baseURL: String? { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeader? { get }
    var body: Encodable? { get }
}

public extension Endpoint {
    var baseURL: String? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var headers: HTTPHeader? { nil }
    var body: Encodable? { nil }
}
