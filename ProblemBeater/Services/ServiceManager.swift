//
//  ServiceManager.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 29/05/25.
//

import Foundation
import SwiftUI

//MARK:- Extension of Data For Apped String
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

class ServiceManager {
    static let shared = ServiceManager()
    private init() {}
    
    func request<T: Decodable>(
        url: URL?,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.requestFailed(error)
        }
    }

    
    
    
    //MARK:- Func for Create Body for multipart Api to append Video and images
    func createBody(parameters: [String: Any?], boundary: String, mimeType: String) throws -> Data {
        var body = Data()
        for (key, value) in parameters {
            if(value is String || value is NSString) {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value ?? "")\r\n")
            } else if let imagValue = value as? UIImage {
                let r = arc4random()
                let filename = "image\(r).jpg" //MARK:  put your imagename in key
                let data: Data = imagValue.jpegData(compressionQuality: 0.5)!
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            }else if value is [String: String] {
                var body1 = Data()
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                for (keyy, valuee) in (value as? [String: String])! {
                    body1.append("--\(boundary)\r\n")
                    body1.append("Content-Disposition: form-data; name=\"\(keyy)\"\r\n\r\n")
                    body1.append("\(valuee)\r\n")
                }
                body.append(body1)
            } else if let dataValue = value as? URL {
                let r = arc4random()
                let filename = "\(r).pdf" //MARK:  put your imagename in key
                let data: Data = try! Data(contentsOf: dataValue)
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
                
            } else if let images = value as? [UIImage] {
                for image in images {
                    let r = arc4random()
                    let filename = "image\(r).jpg" //MARK:  put your imagename in key
                    let data: Data = image.jpegData(compressionQuality: 0.5)!
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                }
            }else if let videoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let r = arc4random()
                let filename = "\(key)\(r).mov" //MARK:  Put you image Name in key
                let data : Data = videoData
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            } else if let multipleData = value as? [Data] { //MARK:  It is used for Multiple Data to api
                for filedata in multipleData {
                    let r = arc4random()
                    let filename = "\(key)\(r).mov" //MARK:-  put your imagename in key
                    let data: Data = filedata
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                }
            }
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    
}
