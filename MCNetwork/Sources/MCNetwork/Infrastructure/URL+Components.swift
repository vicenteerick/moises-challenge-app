//
//  URL+Components.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

extension URL {
    init(baseURL: String, path: String) throws {
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidBaseURL
        }

        components.path += path

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        self = url
    }
}
