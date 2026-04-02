//
//  SongPlayerViewModelTests.swift
//  MoisesChallengeAppTests
//
//  Created by Erick Vicente on 02/04/26.
//

import MCDependencyContainer
import Testing
@testable import MCAudioPlayer
@testable import MoisesChallengeApp


struct SongPlayerViewModelTests {

    @Test @MainActor
    func formatTime_formatsMinutesAndSeconds() {
        let mock = PlayerMock()
        withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            #expect(sut.formatTime(0) == "00:00")
            #expect(sut.formatTime(65) == "01:05")
        }
    }

    @Test @MainActor
    func playPause_whenNotPlaying_callsPlayOnPlayer() {
        let mock = PlayerMock()
        withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            sut.playPause()
            #expect(mock.playCalled)
            #expect(!mock.pauseCalled)
        }
    }

    @Test @MainActor
    func playPause_whenPlaying_callsPauseOnPlayer() async {
        let mock = PlayerMock()
        await withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            Task { @MainActor in await sut.setup() }

            await Task.yield()

            let progress = PlaybackProgress(
                currentTime: 5,
                duration: 120,
                rate: 1,
                state: .playing
            )

            mock.sendProgress(progress)

            await Task.yield()

            sut.playPause()

            await Task.yield()

            #expect(mock.pauseCalled)
        }
    }

    @Test @MainActor
    func nextItem_callsNextOnPlayer() {
        let mock = PlayerMock()
        withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            sut.nextItem()
            #expect(mock.nextItemCalled)
        }
    }

    @Test @MainActor
    func previousItem_callsPreviousOnPlayer() {
        let mock = PlayerMock()
        withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            sut.previousItem()
            #expect(mock.previousItemCalled)
        }
    }

    @Test @MainActor
    func onDisappear_callsUnbuildOnPlayer() {
        let mock = PlayerMock()
        withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            sut.onDisappear()
            #expect(mock.unbuildPlayerCalled)
        }
    }

    @Test @MainActor
    func setup_buildPlayerReceivesMetadataFromSongs() async throws {
        let mock = PlayerMock()
        let song = Song.mock
        try await withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [song])
            Task { @MainActor in await sut.setup() }

            await Task.yield()

            #expect(mock.buildPlayerCalled)
            #expect(mock.buildPlayerItems.count == 1)
            let item = try #require(mock.buildPlayerItems.first)
            #expect(item.title == song.trackName)
            #expect(item.artist == song.artistName)
            #expect(item.assetURL == song.previewUrl)
        }
    }

    @Test @MainActor
    func setup_whenProgressIsPlaying_updatesLabelsAndCurrentSong() async {
        let mock = PlayerMock()
        let song = Song.mock
        await withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [song])
            Task { @MainActor in await sut.setup() }

            await Task.yield()

            let progress = PlaybackProgress(
                currentTime: 45,
                duration: 200,
                rate: 1,
                state: .playing
            )

            mock.sendProgress(progress)

            await Task.yield()

            #expect(sut.isPlaying)
            #expect(sut.currentTime == 45)
            #expect(sut.duration == 200)
            #expect(sut.currentTimeLabel == "00:45")
            #expect(sut.durationLabel == "03:20")
            #expect(sut.currentSongs?.id == song.id)
        }
    }

    @Test @MainActor
    func seek_whenNotScrubbing_seeksAndCallsPlay() async {
        let mock = PlayerMock()
        await withDependency(type: Player.self, dependency: mock) {
            let sut = SongPlayerViewModel(songs: [Song.mock])
            sut.currentTime = 42
            await sut.seek(isEditing: false)

            #expect(mock.seekCalled)
            #expect(mock.seekTime == 42)
            #expect(mock.playCalled)
        }
    }
}
