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
    @StateObject var loadingState: LoadingState
    init() {
        _navManager = StateObject(wrappedValue: NavigationManager())
        _userDetails = StateObject(wrappedValue: SharedUserDetail())
        _loadingState = StateObject(wrappedValue: LoadingState())
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navManager)
                .environmentObject(userDetails)
                .environmentObject(loadingState)
        }
    }
}
