//
//  DashBoardViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 02/06/25.
//

import Combine
import SwiftUI

@MainActor
class DashBoardViewModel: ObservableObject {
    @Published var data: String?
    @Published var logoutSucess = false
    var loadingState: LoadingState?
    
    func fetchData() async {
        await MainActor.run { self.loadingState?.isLoading = true }
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        await MainActor.run { self.loadingState?.isLoading = false }
        logoutSucess = true
        self.data = "Result from API"
    }
}
