//
//  AudioSessionSetup.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 30/03/26.
//

import AVFoundation
public protocol AudioSessionConfigurable {
    func configure() throws
    func deactivate() throws
}

public struct AudioSessionConfiguration: AudioSessionConfigurable {
    public init() {}
    
    public func configure() throws {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            throw AudioError.audioSessionFailed(error)
        }
    }

    public func deactivate() throws {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            throw AudioError.audioSessionFailed(error)
        }
    }
}
