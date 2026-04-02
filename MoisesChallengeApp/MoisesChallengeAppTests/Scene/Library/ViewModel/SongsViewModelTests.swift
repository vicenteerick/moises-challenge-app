//
//  SongsViewModelTests.swift
//  MoisesChallengeAppTests
//
//  Created by Erick Vicente on 02/04/26.
//

import Testing
import MCDependencyContainer
@testable import MoisesChallengeApp

struct SongsViewModelTests {

    @Test @MainActor
    func initialViewState_isEmpty() {
        withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock()
        ) {
            let sut = SongsViewModel()
            #expect(sut.viewState == .empty)
        }
    }

    @Test @MainActor
    func fetchSongs_withError_returnError() async {
        await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock(error: .failed)
        ) {
            let sut = SongsViewModel()
            await sut.fetchSongs(searchTerm: "weezer")

            #expect(sut.viewState == .error(LibraryRepositoryMock.LibraryErrorMock.failed))
        }
    }

    @Test @MainActor
    func fetchSongs_withNoResultItems_returnEmpty() async {
        await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock()
        ) {
            let sut = SongsViewModel()
            await sut.fetchSongs(searchTerm: "")

            #expect(sut.viewState == .empty)
        }
    }

    @Test @MainActor
    func fetchSongs_withMock_returnContent() async throws {
        try await withDependency(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepositoryMock()
        ) {
            let sut = SongsViewModel()
            await sut.fetchSongs(searchTerm: "weezer")

            let songs = try #require(sut.viewState.contentValue)
            #expect(songs.count == 2)
            let names = songs.map(\.trackName)
            #expect(names == ["My Name Is Jonas", "No One Else"])
        }
    }
}
