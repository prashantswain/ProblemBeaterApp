//
//  ForgotRequestModel.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//

struct SucessMessage: Decodable {
    let message: String
    enum CodingKeys: String, CodingKey {
        case message = "mesaage" // Fix typo from backend
    }
}


struct ForgotPasswordRequest: Encodable {
    let email: String
    let password: String
}
