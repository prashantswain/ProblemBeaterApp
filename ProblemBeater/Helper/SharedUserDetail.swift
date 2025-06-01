//
//  SharedUserDetail.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 31/05/25.
//
import SwiftUI

@MainActor
class SharedUserDetail: ObservableObject {
    @Published var user: UserData?
    @AppStorage("appInstalled") var isAppInstalled: Bool = false
    @AppStorage("userLoggedIn") var isUserLoggedIn: Bool = false
    
    let userDefault = UserDefaults.standard
    let userDataKey = "userData"
    
    init() {
        self.user = appUserDefault.getUserFromUserDefaults()
    }
    
//    func login(user: UserData) {
//        self.user = user
//        saveUserToUserDefaults(user)
//    }
//    
//    func logout() {
//        user = nil
//        userDefault.removeObject(forKey: userDataKey)
//    }
}
