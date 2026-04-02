//
//  Encodable+Data.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

extension Encodable {
    func toData() throws -> Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            throw NetworkError.encodeError("\(error)")
        }
    }
}
