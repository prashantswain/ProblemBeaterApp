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
    
    @AppStorage("appInstalled") var isAppInstalled: Bool = false
    @AppStorage("userLoggedIn") var isUserLoggedIn: Bool = false
}
