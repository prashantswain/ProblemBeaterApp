//
//  NavigationView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import SwiftUI

enum NavigationScreen: Hashable {
    case login(Bool, String)
    case signUp
    case forgotPassword
    case home(Bool)
    case walkThrough
}

@MainActor
class NavigationManager: ObservableObject {
    @EnvironmentObject var userDetail: SharedUserDetail
    @Published var path = NavigationPath()
    
    func goToHome(showWelcomeAlert: Bool = false) async {
        appUserDefault.isUserLoggedIn = true
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
            self.path.append(NavigationScreen.home(showWelcomeAlert))
        }
    }
    
    func goToLogin(showToastMessage: Bool = true, message: String) async {
        print("goToLogin called. Current path: \(path)")
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
            self.path.append(NavigationScreen.login(showToastMessage, message))
        }
        print("goToLogin appended login screen. : \(path)")
    }
    
    func logout() {
        Task {
            await goToLogin(showToastMessage: true, message: "Logut Successfully")
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
                await goToLogin(showToastMessage: false, message: "")
            }
        }
    }
}


