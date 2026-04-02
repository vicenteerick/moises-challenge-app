//
//  NetworkClient.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

public protocol NetworkClient {
    func request<T: Decodable>(setup: Endpoint) async throws -> T
}
