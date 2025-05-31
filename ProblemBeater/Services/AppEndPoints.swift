//
//  AppEndPoints.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 30/05/25.
//
import SwiftUI

protocol EndPointConfig {
    var url: URL { get }
    var completeUrl: String { get }
    var path: String { get }
    var httpMethod: httpMethod { get set}
    //    var encoding: ParameterEncoding { get }
}

//MARK:- Enum For httpsMethos
enum httpMethod: String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
    case delete = "delete"
    case head   = "head"
}

//MARK:- Extension of Data For Apped String
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

enum ContentType: String {
    case applicationJson = "application/json"
    case type = "Content-Type"
    case accessToken = "Authorization"
    case response = "data"
    case message = "message"
}

enum EndPoint: EndPointConfig {
    case none
    case getAllClasses
    case login
    case signUp
    
    var path: String {
        switch self {
        case .getAllClasses:
            return "getAllClasses"
        case .login:
            return "auth/login"
        case .signUp:
            return "user/createProfile"
        default:
            return ""
        }
    }
    
    
    static var httpType: httpMethod = .post
    var url: URL {
        let respectiveBaseUrl = self.completeUrl
        guard let url = URL(string: respectiveBaseUrl.replacingOccurrences(of: " ", with: "%20")) else {
            fatalError("invalid base url!")
        }
        return url
    }
    
    var completeUrl: String {
        return path.contains("http") ? path : (baseUrlString + path)
    }
    
    var httpMethod: httpMethod {
        get {
            switch self {
            default: return EndPoint.httpType
            }
        }
        set(newValue) {
            EndPoint.httpType = newValue
        }
    }
    
    var accessToken: String {
        appUserDefault.accessToken
    }
    
    var baseUrlString: String {
        return "http://localhost:8000//v1/problem_beater/"
    }
}

enum ApiParameter: String {
    case name = "name"
    case email = "emailID"
    case mobile = "mobileNumber"
    case age = "age"
    case gender = "gender"
    case password = "password"
    case classId = "classId"
    case profilePic = "profile_picture"
    
    
    var key: String {
        return self.rawValue
    }
}
