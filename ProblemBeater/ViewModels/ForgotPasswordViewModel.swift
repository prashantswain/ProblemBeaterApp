//
//  ForgotPasswordViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 29/05/25.
//

import Combine
import SwiftUI

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var data: String?
    @Published var isLoading = false
    // TextField
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var passwordChanged = false
    
    
    func validationField() -> Bool {
        if email.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyEmail)
            return false
        } else if !email.isValidEmail() {
            ValidationErrorManager.shared.show(error: .inValidEmail)
            return false
        } else if password.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyNewPaasword)
            return false
        } else if password.isPasswordValidate() {
            ValidationErrorManager.shared.show(error: .validPassword)
            return false
        } else if confirmPassword.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyConfirmPass)
            return false
        } else if password != confirmPassword {
            ValidationErrorManager.shared.show(error: .confirmPasswordNotMatch)
            return false
        }
        ValidationErrorManager.shared.clear()
        return true
    }
    
    func fetchData() async {
//        guard validationField() else { return }
        isLoading = true
            try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        isLoading = false
            self.data = "Result from API"
        passwordChanged = true
    }
}
