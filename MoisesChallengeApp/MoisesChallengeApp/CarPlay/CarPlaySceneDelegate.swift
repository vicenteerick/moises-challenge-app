//
//  CarPlaySceneDelegate.swift
//  CPHelloWorld
//
//  Created by Paul Wilkinson on 16/5/2023.
//

import Foundation
import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {

    var interfaceController: CPInterfaceController?
    private var templateManager: CarPlayTemplateManager?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        AppSetup.registerDependencies()

        self.interfaceController = interfaceController

        // TODO: Be able to play musics independently from the iPhone
        let nowPlayingTemplate = CPNowPlayingTemplate.shared
        nowPlayingTemplate.isAlbumArtistButtonEnabled = true

        let manager = CarPlayTemplateManager()
        manager.interfaceController = interfaceController
        nowPlayingTemplate.add(manager)
        templateManager = manager

        // TODO: Change the initial template to show the last musics listened
        // TODO: to user be able to open the carplay app before open the iphone app
        // TODO: and play music
        self.interfaceController?.setRootTemplate(nowPlayingTemplate, animated: false, completion: nil)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        if let manager = templateManager {
            CPNowPlayingTemplate.shared.remove(manager)
        }
        templateManager = nil
        self.interfaceController = nil
    }
}
