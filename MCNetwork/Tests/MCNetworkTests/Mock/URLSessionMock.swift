//
//  URLSessionMock.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation
@testable import MCNetwork

enum ErrorTest: Error {
    case missingURLResponse
}

class URLSessionMock: URLSessionAsyncable {
    var data: Data?
    var error: Error?
    var urlResponse: URLResponse?

    init(data: Data?, urlResponse: URLResponse?) {
        self.data = data
        self.urlResponse = urlResponse
    }

    func dataTask(
        for request: URLRequest
    ) async throws -> (data: Data, response: URLResponse) {
        guard let urlResponse else { throw ErrorTest.missingURLResponse }
        return (data ?? Data(), urlResponse)
    }
}
