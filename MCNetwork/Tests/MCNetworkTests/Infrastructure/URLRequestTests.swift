//
//  URLRequestTests.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation
import Testing
@testable import MCNetwork

struct URLRequestTests {

    private func makeRequest(_ setup: EndpointMock = .detail) throws -> URLRequest {
        try URLRequest(
            baseURL: "https://www.test.com",
            setup: setup
        )
    }

    @Test
    func dataTask_whenValid_shouldReturn() async throws {
        let request = try makeRequest()

        let dataTask = try? await URLSession(configuration: .default)
            .dataTask(for: request)

        #expect(dataTask != nil)
    }

    @Test
    func initURLRequest_shouldHandlePath() {
        let detail = try? makeRequest()
        #expect(detail?.url?.path == "/item/detail")

        let images = try? makeRequest(.images)
        #expect(images?.url?.path == "/item/images")
    }

    @Test
    func initURLRequest_shouldHandleBodyParameters() {
        let request = try? makeRequest()

        #expect(request?.httpBody != nil)
        #expect(request?.url?.query == nil)
    }

    @Test
    func initURLRequest_shouldHandleQueryParameters() {
        let request = try? makeRequest(.imagesFiltered("test"))
        #expect(request?.httpBody == nil)
        #expect(request?.url?.query(percentEncoded: true) == "param=test")
    }

    @Test
    func initURLRequest_shouldHandleMethod() {
        let detail = try? makeRequest()
        #expect(detail?.httpMethod == "POST")

        let images = try? makeRequest(.images)
        #expect(images?.httpMethod == "GET")
    }

    @Test
    func initURLRequest_shouldHandleHeader_forBodyParameters() {
        let request = try? makeRequest()
        #expect(request?.value(forHTTPHeaderField: "header") == "test")
        #expect(request?.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test
    func initURLRequest_shouldHandleHeader_forQueryParameters() {
        let request = try? makeRequest(.images)
        #expect(request?.value(forHTTPHeaderField: "header") == "test")
        #expect(request?.value(forHTTPHeaderField: "Content-Type") == nil)
    }
}
