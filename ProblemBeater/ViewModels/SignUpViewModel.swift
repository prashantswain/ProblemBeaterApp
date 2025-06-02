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
    
    @Published var signUpSuccess = false
    @Published var classes: [ClassItem]?
    
    var loadingState: LoadingState?
    
    
    func fetClasses() async {
        await MainActor.run { self.loadingState?.isLoading = true }
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        ServiceManager.shared.getRequest(endpoint: .getAllClasses) { (result: Result<ClassesResponse, APIError>) in
            Task {
                await MainActor.run { self.loadingState?.isLoading = false }
            }
            switch result {
            case .success(let classResponce):
                DispatchQueue.main.async {
                    self.classes = classResponce.data
                }
            case .failure(let error):
                ValidationErrorManager.shared.show(error: .customError(error.errorDescription ?? ""))
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
        } else if getClassId() == 0 {
            ValidationErrorManager.shared.show(error: .emptyClass)
            return false
        }
        ValidationErrorManager.shared.clear()
        return true
    }
    
    func signUp() async {
        guard validationField() else { return }
        await MainActor.run { self.loadingState?.isLoading = true }
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        let parameters : [String : Any] = [
            ApiParameter.name.key: name,
            ApiParameter.email.key: email,
            ApiParameter.mobile.key: String.toString(mobile),
            ApiParameter.age.key: String.toString(age),
            ApiParameter.gender.key: selectedGender,
            ApiParameter.password.key: password,
            ApiParameter.classId.key: String.toString(getClassId()),
            ApiParameter.profilePic.key: selectedImage ?? UIImage()
        ]
        
        ServiceManager.shared.postMultipartRequest(endpoint: .signUp, requestParameter: parameters) { (result: Result<SignUpResponse, APIError>) in
            Task {
                await MainActor.run { self.loadingState?.isLoading = false }
            }
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.signUpSuccess = true
                }
            case .failure(let error):
                ValidationErrorManager.shared.show(error: .customError(error.errorDescription ?? ""))
            }
        }
    }
    
    func getClassId() -> Int {
        return self.classes?.filter{$0.name == selectedClass}.first?.id ?? 0
    }
}
