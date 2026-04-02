//
//  PlayerState.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 01/04/26.
//

import AVFoundation

public enum PlayerState: Sendable {
    case playing
    case paused
    case buffering

    init(from status: AVPlayer.TimeControlStatus) {
        self = switch status {
        case .waitingToPlayAtSpecifiedRate: .buffering
        case .playing: .playing
        case .paused: .paused
        @unknown default: .paused
        }
    }
}
