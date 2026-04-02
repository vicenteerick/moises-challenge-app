//
//  URLSessionNetworkClientTests.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation
import Testing
@testable import MCNetwork

struct URLSessionNetworkClientTests {

    private func makeUrlResponse(
        statusCode: Int = 200
    ) -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "https://www.test.com")!,
                        statusCode: statusCode,
                        httpVersion: nil,
                        headerFields: nil)
    }

    private func makeUrlSession(
        data: Data? = "".data(using: .utf8),
        urlResponse: URLResponse? = nil,
        statusCode: Int = 200
    ) -> URLSessionMock {
        URLSessionMock(
            data: data,
            urlResponse: urlResponse ?? makeUrlResponse(statusCode: statusCode)
        )
    }

    private func makeNetworkClient(
        baseURL: String = "https://www.test.com",
        session: URLSessionMock? = nil,
        data: Data? = "".data(using: .utf8),
        statusCode: Int = 200
    ) -> NetworkClient {
        URLSessionNetworkClient(
            baseURL: baseURL,
            session: session ?? makeUrlSession(data: data, statusCode: statusCode)
        )
    }

    @Test
    func testRequest_WhenInvalidURL_ShouldFail() async throws {
        let client = makeNetworkClient(baseURL: "http://test.com:-80/")
        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .invalidBaseURL)
        }
    }

    @Test
    func testRequest_WhenIsNotHTTPUrlResponse_ShouldFail() async throws {
        let urlResponse =  URLResponse(
            url: URL(fileURLWithPath: ""),
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let client = makeNetworkClient(
            baseURL: "http://test.com:-80/",
            session: makeUrlSession(urlResponse: urlResponse)
        )

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .invalidBaseURL)
        }
    }

    @Test
    func testRequest_WhenStatusCodeIs401_ShouldFail() async throws {
        let client = makeNetworkClient(statusCode: 401)

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .authenticationRequired)
        }
    }

    @Test
    func testRequest_WhenStatusCodeIs404_ShouldFail() async throws {
        let client = makeNetworkClient(statusCode: 404)

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .hostNotFound)
        }
    }

    @Test
    func testRequest_WhenStatusCodeIs409_ShouldFail() async throws {
        let client = makeNetworkClient(statusCode: 409)

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .alreadyExist)
        }
    }

    @Test
    func testRequest_WhenStatusCodeIs500_ShouldFail() async throws {
        let client = makeNetworkClient(statusCode: 500)

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .badRequest)
        }
    }

    @Test
    func testRequest_WhenAnyFailedStatusCode_ShouldFail() async throws {
        let client = makeNetworkClient(statusCode: 402)

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error {
            #expect(error as? NetworkError == .statusCodeRequestFail(402))
        }
    }

    @Test
    func testRequest_WhenIsSuccessStatusCode_AndCannotParseData_ToObjectResponse_ShouldFail() async throws {
        let data = "{\"response\": 10}".data(using: .utf8)
        let client = makeNetworkClient(data: data)

        do {
            let _: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(Bool(false), "Expected to throw error")
        } catch let error as NetworkError {
            #expect(error == .decodeError("The data couldn’t be read because it isn’t in the correct format."))
        } catch {
            #expect(Bool(false), "Unexpected error type")
        }
    }

    @Test
    func testRequest_WhenIsSuccessStatusCode_AndResponseData_ShouldReturnSuccess() async throws {
        let data = "{\"response\": \"Success\"}".data(using: .utf8)
        let client = makeNetworkClient(data: data)

        do {
            let success: SuccessStub = try await client.request(
                setup: EndpointMock.detail
            )
            #expect(success.response == "Success")
        } catch {
            #expect(Bool(false), "Unexpected error type")
        }
    }
}
