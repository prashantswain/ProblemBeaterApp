//
//  SignUp.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI
import Foundation

struct Gender: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

let genders = ["Male", "Female"]
let classes = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

// MARK: - Root Response
struct ClassesResponse: Decodable {
    let data: [ClassItem]
    let message: String
}

// MARK: - Single Class Item
struct ClassItem: Codable, Identifiable {
    let id: Int
    let createdAt: String?
    let updatedAt: String?
    let name: String
}


// MARK: - SignUpResponse
struct SignUpResponse: Decodable {
    let data: UserData
    let message: String

    enum CodingKeys: String, CodingKey {
        case data
        case message = "mesaage" // Fix typo from backend
    }
}
