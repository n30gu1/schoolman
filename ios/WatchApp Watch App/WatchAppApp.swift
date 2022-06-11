//
//  WatchAppApp.swift
//  WatchApp Watch App
//
//  Created by Seongheon Park on 2022/06/11.
//

import SwiftUI

@main
struct WatchApp_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(watchOS 9.0, *) {
                NavigationStack {
                    ContentView()
                }
            } else {
                NavigationView {
                    ContentView()
                }
            }
        }
    }
}
