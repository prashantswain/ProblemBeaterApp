//
//  ProblemBeaterApp.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

@main
struct ProblemBeaterApp: App {
    @StateObject var navManager: NavigationManager
    @StateObject var userDetails: SharedUserDetail
    init() {
        _navManager = StateObject(wrappedValue: NavigationManager())
        _userDetails = StateObject(wrappedValue: SharedUserDetail())
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navManager)
                .environmentObject(userDetails)
        }
    }
}
