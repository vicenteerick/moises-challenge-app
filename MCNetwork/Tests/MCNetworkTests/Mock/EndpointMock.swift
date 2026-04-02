//
//  EndpointMock.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation
import MCNetwork

struct ParameterMock: Encodable {
    let param: String = "test"
}

enum EndpointMock: Endpoint {
    case detail
    case images
    case imagesFiltered(String)

    var path: String {
        switch self {
        case .detail:
            return "/item/detail"
        case .images, .imagesFiltered:
            return "/item/images"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .imagesFiltered(param):
            return [URLQueryItem(name: "param", value: param)]
        default:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case .detail:
            return ParameterMock()
        default:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .detail:
            return .post
        case .images, .imagesFiltered:
            return .get
        }
    }

    var headers: HTTPHeader? { ["header": "test"] }
}
