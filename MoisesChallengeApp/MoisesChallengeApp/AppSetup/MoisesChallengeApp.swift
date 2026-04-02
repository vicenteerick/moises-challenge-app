//
//  MoisesChallengeApp.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 27/03/26.
//

import SwiftUI

@main
struct MoisesChallengeApp: App {

    init () {
        AppSetup.registerDependencies()
    }

    var body: some Scene {
        WindowGroup {
            LibraryNavigationView()
                .preferredColorScheme(.dark)
        }
    }
}
