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
    //TextField
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var mobile: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var age: String = ""
    @Published var selectedGender: String = ""
    @Published var selectedClass: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var data: String?
    @Published var isLoading = false
    
    @Published var loginSuccess = false
    @Published var classes: [ClassItem]?
    var errorMessage: String?
    @Published var showError = false
    
    func fetchData() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        isLoading = false
        self.data = "Result from API"
    }
    
    
    func fetClasses() {
        ServiceManager.shared.getRequest(endpoint: .getAllClasses) { (result: Result<ClassesResponse, APIError>) in
            switch result {
            case .success(let classResponce):
                self.classes = classResponce.data
            case .failure(let error):
                self.errorMessage = error.errorDescription
                self.showError = true
            }
        }
    }
    
    func validationField() -> Bool {
        if selectedImage == nil {
            ValidationErrorManager.shared.show(error: .selectProfilePicture)
            return false
        } else if name.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyName)
            return false
        } else if email.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyEmail)
            return false
        } else if !email.isValidEmail() {
            ValidationErrorManager.shared.show(error: .inValidEmail)
            return false
        } else if mobile.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyMobile)
            return false
        } else if !mobile.isNumber() {
            ValidationErrorManager.shared.show(error: .invalidMobile)
            return false
        } else if password.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyPassword)
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
        } else if selectedGender.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyGender)
            return false
        } else if age.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyAge)
            return false
        } else if selectedClass.stringByTrimmingWhiteSpace().isEmpty {
            ValidationErrorManager.shared.show(error: .emptyClass)
            return false
        }
        ValidationErrorManager.shared.clear()
        return true
    }
    
    func signUp() async {
        guard validationField() else { return }
        isLoading = true
        defer {isLoading = false}
        let parameters : [String : Any] = [
            ApiParameter.name.key: "Bhupesh2",
            ApiParameter.email.key: "bhupesh2@gmail.com",
            ApiParameter.mobile.key: "9876545678",
            ApiParameter.age.key: "23",
            ApiParameter.gender.key: "Male",
            ApiParameter.password.key: "12345678",
            ApiParameter.classId.key: "4",
            ApiParameter.profilePic.key: UIImage(systemName: "person.circle")!
        ]
        
        ServiceManager.shared.postMultipartRequest(endpoint: .signUp, requestParameter: parameters) { (result: Result<SignUpResponse, APIError>) in
            switch result {
            case .success(let loginResponse):
                self.showMessage(message: loginResponse.message)
                self.errorMessage = loginResponse.message
                self.showError = true
            case .failure(let error):
                self.showMessage(message: error.errorDescription ?? "")
            }
        }
    }
    
    func showMessage(message: String) {
        print(message)
    }
}
