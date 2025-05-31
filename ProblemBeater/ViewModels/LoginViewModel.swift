//
//  LoginViewModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    
    // TextField
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var data: String?
    @Published var isLoading = false
    @Published var isLoggedInSuucess: Bool = false
    @Published var validationError: String = ""
    @Published var showToast: Bool = false
    var toastMessage = ""
    
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
        isLoading = true
        defer {isLoading = false}
        guard ValidationField() else { return }
        let requestParameter = LoginRequest(username: "bhupesh2@gmail.com", password: "87654321@Abc")
        ServiceManager.shared.postRequest(endpoint: .login, requestParameter: requestParameter) { (result: Result<LoginResponse, APIError>) in
            switch result {
            case .success(let loginResponse):
                self.showMessage(message: loginResponse.message)
                self.isLoggedInSuucess = true
            case .failure(let error):
                self.showMessage(message: error.errorDescription ?? "")
            }
        }
    }
    
    func showMessage(message: String) {
        print(message)
    }
}
