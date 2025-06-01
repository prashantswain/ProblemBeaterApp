//
//  NavigationView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import SwiftUI

@MainActor
class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    private var savedStates: [String: NavigationPath.CodableRepresentation] = [:]
    
    
    func navigate<T: Navigate>(to destination: T) {
        path.append(AnyNavigate(destination))
    }
    
    // Save current navigation state with a key
    func saveState<T: Navigate & Hashable>(named name: T.Type) {
        if let codable = path.codable {
            savedStates[String(describing: name)] = codable
            print("Saved state for '\(String(describing: name))'")
        }
    }
    
    // Restore saved navigation state
    func restoreState<T: Navigate & Hashable>(named name: T.Type) {
        if let codable = savedStates[String(describing: name)] {
            path = NavigationPath(codable)
            print("Restored state for '\(String(describing: name))'")
        } else {
            print("No saved state found for '\(String(describing: name))'")
        }
    }
    
    func goToHome(showToastMessage: Bool = false, message: String = "") async {
        appUserDefault.isUserLoggedIn = true
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
            self.navigate(to: HomeScreenNavigation(showToast: showToastMessage, toastMessage: message))
        }
    }
    
    func goToLogin(showToastMessage: Bool = false, message: String) async {
        // print("goToLogin called. Current path: \(path)")
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
            self.navigate(to: LoginNavigation(showToast: showToastMessage, toastMessage: message))
        }
        // print("goToLogin appended login screen. : \(path)")
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
                    self.path.append(AnyNavigate(WalkThroughNavigation()))
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
    
    func pop() {
        path.removeLast()
    }
}




