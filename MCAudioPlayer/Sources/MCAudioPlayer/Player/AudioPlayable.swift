//
//  AudioPlayable.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 01/04/26.
//

import AVFoundation

@MainActor
protocol AudioPlayable {
    func play()
    func pause()
}

extension AVPlayer: AudioPlayable { }
