//
//  URLSessionNetworkClient.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation
import OSLog

public final class URLSessionNetworkClient: NetworkClient {
    private let baseURL: String
    private let session: URLSessionAsyncable
    private let logger = Logger(subsystem: "Network", category: "URLSessionNetworkClient")

    public init(
        baseURL: String,
        session: URLSessionAsyncable = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func request<T: Decodable>(
        setup endpoint: Endpoint
    ) async throws -> T {
        do {
            let baseURL = endpoint.baseURL ?? baseURL
            let request = try URLRequest(baseURL: baseURL, setup: endpoint)
            
            logger.log("REQUEST")
            logger.log("\(request.description)")

            let (data, response) = try await session.dataTask(for: request)

            logger.log("RESPONSE")
            logger.log("\(response.description)")
            logger.log("\(String(data: data, encoding: .utf8) ?? "")")

            guard let urlResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            if let error = handleStatusError(code: urlResponse.statusCode) {
                throw error
            }

            return try data.decode()
        } catch let error as NetworkError {
            logger.error("\(error)")
            throw error
        } catch {
            logger.error("\(error)")
            throw NetworkError.unknown(error.localizedDescription)
        }
    }

    private func handleStatusError(code: Int) -> NetworkError? {
        switch code {
        case 200...299:
            nil
        case 401:
            .authenticationRequired
        case 404:
            .hostNotFound
        case 409:
            .alreadyExist
        case 500:
            .badRequest
        default:
            .statusCodeRequestFail(code)
        }
    }
}
