//
//  LoginViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import Combine
import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    
    // TextField
    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isLoggedInSuucess: Bool = false
    @Published var showToast: Bool = false
    var toastMessage = ""
    
    var loadingState: LoadingState?
    
    init(showToast: Bool = false, toastMessage: String = "") {
        self.showToast = showToast
        self.toastMessage = toastMessage
    }

    func ValidationField() -> Bool {
        if email.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyEmail)
            return false
        } else if !email.isValidEmail() {
            ValidationErrorManager.shared.show(error: .inValidEmail)
            return false
        } else if password.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyPassword)
            return false
        } else if password.isPasswordValidate() {
            ValidationErrorManager.shared.show(error: .validPassword)
            return false
        }
        ValidationErrorManager.shared.clear()
        return true
    }
    
    func login() async {
        await MainActor.run { self.loadingState?.isLoading = true }
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        guard ValidationField() else { return }
        let requestParameter = LoginRequest(username: email, password: password)
        ServiceManager.shared.postRequest(endpoint: .login, requestParameter: requestParameter) { (result: Result<LoginResponse, APIError>) in
            Task {
                await MainActor.run { self.loadingState?.isLoading = false }
            }
            switch result {
            case .success(let loginResponse):
                appUserDefault.saveUserToUserDefaults(loginResponse.data)
                appUserDefault.accessToken = loginResponse.authToken
                DispatchQueue.main.async {
                    self.isLoggedInSuucess = true
            }
            case .failure(let error):
                ValidationErrorManager.shared.show(error: .customError(error.errorDescription ?? ""))
            }
        }
    }
    
    func showMessage(message: String) {
        print(message)
    }
}
