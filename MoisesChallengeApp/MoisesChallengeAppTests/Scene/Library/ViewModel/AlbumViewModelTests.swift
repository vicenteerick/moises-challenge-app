//
//  AlbumViewModelTests.swift
//  MoisesChallengeAppTests
//
//  Created by Erick Vicente on 02/04/26.
//

import MCDependencyContainer
import Testing
@testable import MoisesChallengeApp

struct AlbumViewModelTests {

    @Test @MainActor
    func initialViewState_isLoading() {
        withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock()
        ) {
            let sut = AlbumViewModel(collectionId: "1440878798", onTapSong: { _ in })
            #expect(sut.viewState == .loading)
        }
    }

    @Test @MainActor
    func fetchAlbum_withError_returnsError() async {
        await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock(error: .failed)
        ) {
            let sut = AlbumViewModel(collectionId: "1440878798", onTapSong: { _ in })
            await sut.fetchAlbum()

            #expect(sut.viewState == .error(LibraryRepositoryMock.LibraryErrorMock.failed))
        }
    }

    @Test @MainActor
    func fetchAlbum_withoutCollection_returnsEmpty() async {
        let noCollection = LibraryResponse(
            resultCount: 2,
            results: [.mockTrack1, .mockTrack2]
        )
        await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock(getAlbumResponse: noCollection)
        ) {
            let sut = AlbumViewModel(collectionId: "1440878798", onTapSong: { _ in })
            await sut.fetchAlbum()

            #expect(sut.viewState == .empty)
        }
    }

    @Test @MainActor
    func fetchAlbum_emptyResults_returnsEmpty() async {
        let empty = LibraryResponse(resultCount: 0, results: [])
        await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock(getAlbumResponse: empty)
        ) {
            let sut = AlbumViewModel(collectionId: "1440878798", onTapSong: { _ in })
            await sut.fetchAlbum()

            #expect(sut.viewState == .empty)
        }
    }

    @Test @MainActor
    func fetchAlbum_withMock_returnsContent() async throws {
        try await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock()
        ) {
            let sut = AlbumViewModel(collectionId: "1440878798", onTapSong: { _ in })
            await sut.fetchAlbum()

            let album = try #require(sut.viewState.contentValue)
            #expect(album.name == "Weezer")
            #expect(album.artistName == "Weezer")
            #expect(album.songs.count == 2)
            let names = album.songs.map(\.trackName)
            #expect(names == ["My Name Is Jonas", "No One Else"])
        }
    }

    @Test @MainActor
    func selectSong_passesSelectedSongFirstThenRemainingAlbumSongs() async throws {
        try await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock()
        ) {
            var received: [Song]?
            let sut = AlbumViewModel(collectionId: "1440878798") { songs in
                received = songs
            }
            await sut.fetchAlbum()

            let album = try #require(sut.viewState.contentValue)
            let firstSong = try #require(album.songs.first)
            let secondSong = try #require(album.songs.dropFirst().first)

            sut.selectSong(secondSong)

            let out = try #require(received)
            #expect(out.count == 2)
            #expect(out[0].id == secondSong.id)
            #expect(out[1].id == firstSong.id)
        }
    }
}
