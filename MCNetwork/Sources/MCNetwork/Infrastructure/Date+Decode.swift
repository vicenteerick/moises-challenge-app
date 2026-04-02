//
//  Date+Decode.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

extension Data {
    func decode<T: Decodable>() throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            throw NetworkError.decodeError("\(error)")
        }
    }
}
