//
//  PlayerMock.swift
//  MCAudioPlayer
//
//  Created by Erick Vicente on 02/04/26.
//

public final class PlayerMock: Player {

    // MARK: - State tracking

    public private(set) var currentItem: PlayerItemMetadata?

    public private(set) var buildPlayerCalled = false
    public private(set) var buildPlayerItems: [PlayerItemMetadata] = []

    public private(set) var playCalled = false
    public private(set) var pauseCalled = false

    public private(set) var seekCalled = false
    public private(set) var seekTime: Double?

    public private(set) var nextItemCalled = false
    public private(set) var previousItemCalled = false

    public private(set) var unbuildPlayerCalled = false

    // MARK: - Playback Stream Control

    private var continuation: AsyncStream<PlaybackProgress>.Continuation?

    // Store last emitted value if you want assertions
    private(set) var emittedProgress: [PlaybackProgress] = []

    public init() { }

    // MARK: - Protocol

    public func buildPlayer(items: [PlayerItemMetadata]) async {
        buildPlayerCalled = true
        buildPlayerItems = items
        currentItem = items.first
    }

    public func play() throws {
        playCalled = true
    }

    public func pause() {
        pauseCalled = true
    }

    public func seek(to time: Double) async {
        seekCalled = true
        seekTime = time
    }

    public func nextItem() {
        nextItemCalled = true
    }

    public func previousItem() {
        previousItemCalled = true
    }

    public func playbackProgress() -> AsyncStream<PlaybackProgress> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    public func unbuildPlayer() {
        unbuildPlayerCalled = true
        continuation?.finish()
    }
}

public extension PlayerMock {

    func sendProgress(_ progress: PlaybackProgress) {
        emittedProgress.append(progress)
        continuation?.yield(progress)
    }

    func finishProgress() {
        continuation?.finish()
    }
}
