//
//  NetworkError.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidBaseURL
    case invalidURL
    case invalidResponse
    case invalidData
    case authenticationRequired
    case hostNotFound
    case alreadyExist
    case badRequest
    case encodeError(String)
    case decodeError(String)
    case statusCodeRequestFail(Int)
    case unknown(String)
}
