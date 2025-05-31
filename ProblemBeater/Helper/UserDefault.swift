//
//  UserDefault.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import SwiftUI

class AppUserDefault {
    static let shared = AppUserDefault()
    
    private init () {}
    var navManager: NavigationManager?
    @AppStorage("appInstalled") var isAppInstalled: Bool = false
    @AppStorage("userLoggedIn") var isUserLoggedIn: Bool = false
    @AppStorage("accessToken") var accessToken: String = ""
    
    let userDataKey = "userData"
    
    func saveUserToUserDefaults(_ user: UserData) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDataKey)
        }
    }
    
    func getUserFromUserDefaults() -> UserData? {
        if let data = UserDefaults.standard.data(forKey: userDataKey) {
            if let decodedUser = try? JSONDecoder().decode(UserData.self, from: data) {
                return decodedUser
            }
        }
        return nil
    }
}
