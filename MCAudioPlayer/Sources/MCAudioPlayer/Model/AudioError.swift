//
//  AudioError.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 30/03/26.
//

import Foundation

enum AudioError: Error {
    case audioSessionFailed(Error)
    case audioPlayerContentFailed(Error)
}
