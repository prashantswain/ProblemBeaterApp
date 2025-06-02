//
//  ContentView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var userDetail: SharedUserDetail
    @EnvironmentObject var loadingState: LoadingState
    @State private var showSplash = true
    var body: some View {
        NavigationStack(path: $navManager.path) {
            VStack {
                Group {
                    if showSplash {
                        SplashScreen()
                    } else {
                        EmptyView()
                    }
                }
            }
            .onAppear {
                appUserDefault.navManager = navManager
                appUserDefault.userDetail = userDetail
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    showSplash = false
                    navManager.navigateToRoot()
                }
            }
            .overlay(
                CustomValidationAlertView() // Alert View
            )
            .navigationDestination(for: AnyNavigate.self) { nav in
                print("Check navigation")
                return nav.destinationView()
                
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager())
}
