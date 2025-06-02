//
//  HomeScreenViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 29/05/25.
//

import Combine
import SwiftUI

@MainActor
class HomeScreenViewModel: ObservableObject {
    
    @Published var showLoginToast = false
    var welcomeMessage = ""
    
    init(showLoginToast: Bool = false, wecomeMessage: String = "") {
        self.showLoginToast = showLoginToast
        self.welcomeMessage = wecomeMessage
    }
    
}

