//
//  URLTests.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation
import Testing
@testable import MCNetwork

struct URLTests {
    @Test
    func initURL_whenInvalid_shouldThrowError() {
        do {
            _ = try URL(baseURL: "http://test.com:-80/", path: "")
            #expect(Bool(false), "Expected to throw error")
        } catch let error as NetworkError {
            #expect(error == .invalidBaseURL)
        } catch {
            #expect(Bool(false), "Unexpected error type")
        }
    }

    @Test
    func initURL_whenValid_shouldReturnURLWithPath() {
        let url = try? URL(baseURL: "https://www.test.com", path: "/home")
        #expect(url?.absoluteString == "https://www.test.com/home")
    }
}
