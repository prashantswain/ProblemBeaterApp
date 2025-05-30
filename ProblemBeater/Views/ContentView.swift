//
//  ContentView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navManager: NavigationManager
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    showSplash = false
                    navManager.navigateToRoot()
                }
            }
            .navigationDestination(for: NavigationScreen.self) { screen in
                switch screen {
                case .home:
                    HomeScreen()
                case .login:
                    LoginView()
                case .signUp:
                    RegistrationView()
                case .forgotPassword:
                    ForgotPasswordView()
                case .walkThrough:
                    WalkthroughScreen()
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager())
}
