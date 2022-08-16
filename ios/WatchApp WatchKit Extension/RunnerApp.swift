//
//  RunnerApp.swift
//  WatchApp WatchKit Extension
//
//  Created by Sung Park on 2022/08/12.
//

import SwiftUI

@main
struct RunnerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
