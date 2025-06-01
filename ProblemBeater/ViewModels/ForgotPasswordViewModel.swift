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
            ValidationErrorManager.shared.show(error: .emptyNewPassword)
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
    
    func forgotPassword() async {
        isLoading = true
        defer {isLoading = false}
        guard validationField() else { return }
        let requestParameter = ForgotPasswordRequest(email: email, password: password)
        ServiceManager.shared.postRequest(endpoint: .forgotPassword, requestParameter: requestParameter) { (result: Result<SucessMessage, APIError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.passwordChanged = true
            }
            case .failure(let error):
                ValidationErrorManager.shared.show(error: .customError(error.errorDescription ?? ""))
            }
        }
    }
}
