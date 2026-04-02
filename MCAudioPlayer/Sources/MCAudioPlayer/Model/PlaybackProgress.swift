//
//  PlaybackProgress.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 01/04/26.
//

import Foundation

public struct PlaybackProgress: Sendable {
    public var currentTime: Double
    public var duration: Double
    public var rate: Float
    public var state: PlayerState

    init(currentTime: Double, duration: Double, rate: Float, state: PlayerState) {
        self.currentTime = currentTime
        self.duration = duration
        self.rate = rate
        self.state = state
    }
}
