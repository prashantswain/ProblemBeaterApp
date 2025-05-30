//
//  SignUpViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 29/05/25.
//

import Combine
import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var data: String?
    @Published var isLoading = false
    
    
    @Published var classes: [ClassItem]?
    @Published var errorMessage: String?
    
    func fetchData() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        isLoading = false
        self.data = "Result from API"
    }
    func fetchClasses() async {
        isLoading = true
        defer { isLoading = false }
        
        let url = URL(string: "http://localhost:8000//v1/problem_beater/getAllClasses")
        do {
            let result: ClassesResponse = try await ServiceManager.shared.request(url: url, responseType: ClassesResponse.self)
            self.classes = result.data
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
