//
//  APIErrors.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 29/05/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case authenticationFailed
    case customError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .requestFailed(let err): return "Request failed: \(err.localizedDescription)"
        case .invalidResponse: return "Invalid response from server."
        case .decodingError(let err): return "Failed to decode: \(err.localizedDescription)"
        case .authenticationFailed: return "Authentication Failed!"
        case .customError(let errString): return errString
        }
    }
}
