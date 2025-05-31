//
//  ValidationErrorManager.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 31/05/25.
//

import Foundation

@MainActor
class ValidationErrorManager: ObservableObject {
    static let shared = ValidationErrorManager()
    
    @Published var message: String? = nil
    @Published var showError: Bool = false
    
    private init() {}
    
    func show(error: ValidationError) {
        message = error.rawValue
        showError = true
    }
    
    func clear() {
        showError = false
        message = nil
    }
}

enum ValidationError: String {
    case emptyEmail = "Kindly enter the email address."
    case inValidEmail = "Kindly provide a valid email address."
    case emptyPassword = "Kindly enter the password."
    case validPassword = "Your password must be at least 8 characters with 1 upper case and 1 lower case character, 1 number and 1 spacial character."
    case emptyName = "Kindly enter the name."
    case emptyMobile = "Kindly provide your mobile number."
    case invalidMobile = "Kindly provide a valid mobile number."
    case emptyConfirmPass = "Kindly enter the confirm password."
    case confirmPasswordNotMatch = "Please check your confirm password do not match."
    case emptyNewPaasword = "Kindly enter the new password."
    case emptyGender = "Kindly select gender."
    case emptyAge = "Kindly enter your age."
    case validAge = "Kindly enter your valid age."
    case emptyClass = "Kindly select your class."
    case selectProfilePicture = "Kindly select the profile picture."
}
