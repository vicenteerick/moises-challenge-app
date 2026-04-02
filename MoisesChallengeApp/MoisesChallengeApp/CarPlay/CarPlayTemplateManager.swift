//
//  CarPlayTemplateManager.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 01/04/26.
//

import CarPlay
import Foundation
import MediaPlayer
import MCDependencyContainer
import UIKit

@MainActor
final class CarPlayTemplateManager: NSObject, CPNowPlayingTemplateObserver {

    @Dependencies private var networkLibraryRepository: NetworkLibraryRepository

    weak var interfaceController: CPInterfaceController?

    func collectionIdFromNowPlaying() -> String? {
        let raw = MPNowPlayingInfoCenter
            .default()
            .nowPlayingInfo?[MPNowPlayingInfoCollectionIdentifier]

        guard let string = raw as? String else { return nil }

        return string
    }

    func presentAlbumList() async {
        guard let collectionId = collectionIdFromNowPlaying() else { return }
        guard let interfaceController else { return }

        let response: LibraryResponse

        do {
            response = try await networkLibraryRepository.getAlbum(collectonId: collectionId)
        } catch {
            return
        }

        guard let (title, songs) = Self.parseAlbum(from: response), !songs.isEmpty else { return }

        let listTemplate = await buildAlbumListTemplate(title: title, songs: songs)

        interfaceController.pushTemplate(listTemplate, animated: true, completion: nil)
    }

    private static func parseAlbum(from response: LibraryResponse) -> (title: String, songs: [Song])? {
        var results = response.results
        guard let collectionIndex = results.firstIndex(where: { $0.wrapperType == .collection }) else {
            return nil
        }
        let collection = results.remove(at: collectionIndex)
        let songs = results.compactMap { Song(item: $0) }
        let title = collection.collectionName ?? "Album"
        return (title, songs)
    }

    private func buildAlbumListTemplate(title: String, songs: [Song]) async -> CPListTemplate {
        let playbackPlaying = MPNowPlayingInfoCenter.default().playbackState == .playing

        var items: [CPListItem] = []
        items.reserveCapacity(songs.count)

        for song in songs {
            let artwork = await loadListArtwork(for: song)
            let isCurrent = songMatchesNowPlaying(song)

            let item = CPListItem(
                text: song.trackName,
                detailText: song.artistName,
                image: artwork
            )

            if isCurrent {
                item.isPlaying = true
                item.playingIndicatorLocation = .trailing
            }

            item.handler = { _, completion in
                completion()
            }
            items.append(item)
        }

        let section = CPListSection(items: items)
        return CPListTemplate(title: title, sections: [section])
    }

    private func songMatchesNowPlaying(_ song: Song) -> Bool {
        let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        if let number = info?[MPMediaItemPropertyPersistentID] as? NSNumber, number.intValue == song.id {
            return true
        }
        guard let title = info?[MPMediaItemPropertyTitle] as? String, title == song.trackName else {
            return false
        }
        let artist = info?[MPMediaItemPropertyArtist] as? String
        return artist == song.artistName
    }

    private func loadListArtwork(for song: Song) async -> UIImage {
        let url = song.artwork.url100 ?? song.artwork.url60 ?? song.artwork.url30
        guard let url else { return Self.fallbackMusicImage() }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return Self.fallbackMusicImage() }
            return image
        } catch {
            return Self.fallbackMusicImage()
        }
    }

    private static func fallbackMusicImage() -> UIImage {
        UIImage(systemName: "music.note") ?? UIImage()
    }

    func nowPlayingTemplateAlbumArtistButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {
        Task { await presentAlbumList() }
    }
}
