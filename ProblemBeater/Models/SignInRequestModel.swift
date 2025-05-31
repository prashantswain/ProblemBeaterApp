//
//  SignInRequestModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 30/05/25.
//

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

// MARK: - LoginResponse
struct LoginResponse: Decodable {
    let authToken: String
    let data: UserData
    let message: String

    enum CodingKeys: String, CodingKey {
        case authToken
        case data
        case message = "mesaage" // Fix typo from backend
    }
}

// MARK: - UserData
struct UserData: Codable {
    let id: Int
    let createdAt: String?
    let updatedAt: String?
    let name: String
    let mobileNumber: Int
    let emailID: String
    let gender: String
    let age: Int
    let userClass: ClassItem
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id, createdAt, updatedAt, name, mobileNumber, emailID, gender, age, profilePicture
        case userClass = "class" // because `class` is a reserved keyword in Swift
    }
}
