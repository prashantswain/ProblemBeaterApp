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
    @Published var data: String?
    @Published var isLoading = false

    func fetchData() async {
        isLoading = true
            try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        isLoading = false
            self.data = "Result from API"
    }
}

