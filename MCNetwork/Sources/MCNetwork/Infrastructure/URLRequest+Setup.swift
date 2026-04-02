//
//  URLRequest+Setup.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

extension URLRequest {
    init(baseURL: String, setup: Endpoint) throws {
        var url = try URL(baseURL: baseURL, path: setup.path)

        if let queryItems = setup.queryItems {
            url.append(queryItems: queryItems)
        }

        var urlRequest = URLRequest(url: url)

        if let body = try setup.body?.toData() {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = body
        }

        urlRequest.httpMethod = setup.method.rawValue

        setup.headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        self = urlRequest
    }

    var description: String {
        var textDescription = ""

        if let headers = allHTTPHeaderFields,
           !headers.isEmpty {
            textDescription += "HEADERS: \(String(describing: headers))\n"
        }

        textDescription += "URL: [\(httpMethod ?? "")] \(url?.absoluteString ?? "")\n"

        if let httpBody = httpBody {
            let body = String(data: httpBody, encoding: .utf8) ?? ""
            textDescription += "BODY: \(body)\n"
        }

        return textDescription
    }
}
