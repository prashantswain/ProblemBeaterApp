//
//  NavigationView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import SwiftUI

enum NavigationScreen: Hashable {
    case login
    case signUp
    case forgotPassword
    case home
    case demo
    case walkThrough
}

@MainActor
class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func goToHome() async {
        //        try? await Task.sleep(nanoseconds: 50_000_000)
        appUserDefault.isUserLoggedIn = true
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
            self.path.append(NavigationScreen.home)
        }
    }
    
    func goToLogin() async {
        print("goToLogin called. Current path: \(path)")
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
            self.path.append(NavigationScreen.login)
        }
        //        try? await Task.sleep(nanoseconds: 50_000_000)
        print("goToLogin appended login screen. : \(path)")
    }
    
    func logout() {
        Task {
            await goToLogin()
        }
    }
    func navigateToRoot () {
        if !appUserDefault.isAppInstalled {
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = true
            DispatchQueue.main.async {
                withTransaction(transaction) {
                    self.path.append(NavigationScreen.walkThrough)
                }
            }
        } else if appUserDefault.isUserLoggedIn {
            Task {
                await goToHome()
            }
        } else {
            Task {
                await goToLogin()
            }
        }
    }
}


