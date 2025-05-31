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
                appUserDefault.navManager = navManager
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    showSplash = false
                    navManager.navigateToRoot()
                }
            }
            .overlay(
                CustomValidationAlertView() // Alert View
            )
            .navigationDestination(for: NavigationScreen.self) { screen in
                switch screen {
                case .home(let showAlert):
                    let viewModel = HomeScreenViewModel(showLoginToast: showAlert, wecomeMessage: "Login Successfully")
                    HomeScreen(viewModel: viewModel)
                case .login(let showToast, let toastMessage):
                    let viewModel = LoginViewModel(showToast: showToast, toastMessage: toastMessage)
                    LoginView(viewModel: viewModel)
                case .signUp:
                    RegistrationView()
                case .forgotPassword:
                    ForgotPasswordView()
                case .walkThrough:
                    WalkthroughScreen()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager())
}
