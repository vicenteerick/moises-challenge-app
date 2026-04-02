//
//  URLSessionDataTaskCancelable.swift
//  MCNetwork
//
//  Created by Erick Vicente on 27/03/26.
//

import Foundation

public protocol URLSessionDataTaskCancelable {
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskCancelable { }
