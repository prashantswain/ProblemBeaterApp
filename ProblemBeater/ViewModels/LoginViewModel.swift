//
//  LoginViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var data: String?
    @Published var isLoading = false

    func fetchData() async {
        isLoading = true
            try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        isLoading = false
            self.data = "Result from API"
    }
}
