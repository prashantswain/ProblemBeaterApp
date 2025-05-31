//
//  SharedUserDetail.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 31/05/25.
//
import SwiftUI

@MainActor
class SharedUserDetail: ObservableObject {
    @Published private var user: UserData?
    @AppStorage("appInstalled") var isAppInstalled: Bool = false
    @AppStorage("userLoggedIn") var isUserLoggedIn: Bool = false
    @AppStorage("accessToken") var accessToken: String = ""
    
    let userDefault = UserDefaults.standard
    let userDataKey = "userData"
    
    init() {
        self.user = getUserFromUserDefaults()
    }
    
    func login(user: UserData) {
        self.user = user
        saveUserToUserDefaults(user)
    }
    
    func logout() {
        user = nil
        userDefault.removeObject(forKey: userDataKey)
    }
    
    func saveUserToUserDefaults(_ user: UserData) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefault.set(encoded, forKey: userDataKey)
        }
    }
    
    func getUserFromUserDefaults() -> UserData? {
        if let data = userDefault.data(forKey: userDataKey) {
            if let decodedUser = try? JSONDecoder().decode(UserData.self, from: data) {
                return decodedUser
            }
        }
        return nil
    }
}
