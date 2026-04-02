//
//  AppSetup.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 28/03/26.
//

import Foundation
import MCAudioPlayer
import MCDependencyContainer
import MCNetwork

struct AppSetup {
    static func registerDependencies() {
        DependencyContainer.shared.register(
            type: NetworkClient.self,
            dependency: URLSessionNetworkClient(baseURL: "https://itunes.apple.com"),
            mode: .sharedInstance
        )

        DependencyContainer.shared.register(
            type: NetworkLibraryRepository.self,
            dependency: LibraryRepository(),
            mode: .newInstance
        )

        DependencyContainer.shared.register(
            type: Player.self,
            dependency: AudioPlayer(),
            mode: .sharedInstance
        )
    }
}
