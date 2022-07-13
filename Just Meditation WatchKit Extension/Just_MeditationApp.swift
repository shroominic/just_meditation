//
//  Just_MeditationApp.swift
//  Just Meditation WatchKit Extension
//
//  Created by Fungus on 04.07.22.
//

import SwiftUI

@main
struct Just_MeditationApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                WatchHomeView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
