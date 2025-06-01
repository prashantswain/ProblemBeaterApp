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
        DispatchQueue.main.async {
            self.message = error.errorDescription
            self.showError = true
        }
    }
    
    func clear() {
        DispatchQueue.main.async {
            self.showError = false
            self.message = nil
        }
    }
}

enum ValidationError {
    case emptyEmail
    case inValidEmail
    case emptyPassword
    case validPassword
    case emptyName
    case emptyMobile
    case invalidMobile
    case emptyConfirmPass
    case confirmPasswordNotMatch
    case emptyNewPassword
    case emptyGender
    case emptyAge
    case validAge
    case emptyClass
    case selectProfilePicture
    case customError(String)
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Kindly enter the email address."
        case .inValidEmail:
            return "Kindly provide a valid email address."
        case .emptyPassword:
            return "Kindly enter the password."
        case .validPassword:
            return "Your password must be at least 8 characters with 1 upper case and 1 lower case character, 1 number and 1 special character."
        case .emptyName:
            return "Kindly enter the name."
        case .emptyMobile:
            return "Kindly provide your mobile number."
        case .invalidMobile:
            return "Kindly provide a valid mobile number."
        case .emptyConfirmPass:
            return "Kindly enter the confirm password."
        case .confirmPasswordNotMatch:
            return "Please check your confirm password do not match."
        case .emptyNewPassword:
            return "Kindly enter the new password."
        case .emptyGender:
            return "Kindly select gender."
        case .emptyAge:
            return "Kindly enter your age."
        case .validAge:
            return "Kindly enter your valid age."
        case .emptyClass:
            return "Kindly select your class."
        case .selectProfilePicture:
            return "Kindly select the profile picture."
        case .customError(let message):
            return message
        }
    }
}
