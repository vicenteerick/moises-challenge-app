//
//  URLSessionAsync.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

public protocol URLSessionAsyncable {
    func dataTask(for request: URLRequest
    ) async throws -> (data: Data, response: URLResponse)
}

extension URLSession: URLSessionAsyncable {
    public func dataTask(for request: URLRequest
    ) async throws -> (data: Data, response: URLResponse) {
        try await data(for: request)
    }
}
