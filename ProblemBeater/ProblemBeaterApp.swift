//
//  ProblemBeaterApp.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

@main
struct ProblemBeaterApp: App {
    @StateObject var navManager: NavigationManager = NavigationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navManager)
        }
    }
}
