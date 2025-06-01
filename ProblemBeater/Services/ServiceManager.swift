//
//  ServiceManager.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 29/05/25.
//

import Foundation
import SwiftUI

struct ErrorResponse: Decodable {
    let error: String
}

class ServiceManager {
    static let shared = ServiceManager()
    private init() {}
    
    private func request<T: Decodable>(
        url: URL?,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> (data: T?, statusCode: Int, errorMessage: String?) {
        guard let url = url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
            
            guard 200..<300 ~= httpResponse.statusCode  else {
                if 401..<410 ~= httpResponse.statusCode {
                    let errorDecoded = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    return (nil, httpResponse.statusCode, errorDecoded.error)
                } else {
                    return (nil, httpResponse.statusCode, nil)
                }
            }
            do {
                return  (try JSONDecoder().decode(T.self, from: data), httpResponse.statusCode, nil)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.requestFailed(error)
        }
    }
    
    
    
    // Get Api with CompletionHandler
    func getRequest<T: Decodable>(endpoint: EndPoint,completionHandler: @escaping (Result<T, APIError>) -> Void) {
        // Get all Data for request parameter
        let headers = [
            ContentType.accessToken.rawValue: endpoint.accessToken,
            ContentType.type.rawValue: ContentType.applicationJson.rawValue
        ]
        let method :httpMethod = .get

        Task {
            do {
                let (data, statusCode, errorMessage) = try await request(url: endpoint.url, method: method.rawValue, headers: headers, responseType: T.self)
                if statusCode == 401 {
                    await appUserDefault.navManager?.goToLogin(showToastMessage: false, message: "")
                    completionHandler(.failure(.authenticationFailed))
                    return
                } else if 400..<410 ~= statusCode {
                    completionHandler(.failure(.customError(errorMessage ?? "")))
                    return
                }
                else {
                    guard let data else {
                        completionHandler(.failure(.customError("Data unwrapping failed")))
                        return
                    }
                    completionHandler(.success(data))
                }
            } catch let apiError as APIError {
                completionHandler(.failure(apiError))
            } catch {
                completionHandler(.failure(.customError("Unexpected error: \(error.localizedDescription)")))
            }
        }
    }
    
    // Get Api with Async
    func getRequest<T: Decodable>(endpoint: EndPoint) async -> (T?, APIError?) {
        // Get all Data for request parameter
        let headers = [
            ContentType.accessToken.rawValue: endpoint.accessToken,
            ContentType.type.rawValue: ContentType.applicationJson.rawValue
        ]
        let method :httpMethod = .get
        do {
            let (data, statusCode, errorMessage) = try await request(url: endpoint.url, method: method.rawValue, headers: headers, responseType: T.self)
            if statusCode == 401 {
                Task{
                    await appUserDefault.navManager?.goToLogin(showToastMessage: false, message: "")
                }
                return (nil, .authenticationFailed)
            } else if 400..<410 ~= statusCode {
                return (nil, .customError(errorMessage ?? ""))
            }
            else {
                return (data, nil)
            }
        } catch let apiError as APIError {
            return (nil, apiError)
        } catch {
            return (nil, .customError("Unexpected error: \(error.localizedDescription)"))
        }
    }
    
    // Get Api with CompletionHandler
    func postRequest<T: Decodable>(endpoint: EndPoint, requestParameter: Encodable? = nil, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        // Get all Data for request parameter
        guard let body = requestParameter?.toJSONData() else {
            print("Encoding failed")
            return
        }
        let headers = [
            ContentType.accessToken.rawValue: endpoint.accessToken,
            ContentType.type.rawValue: ContentType.applicationJson.rawValue
        ]
        let method :httpMethod = .post

        Task {
            do {
                let (data, statusCode, errorMessage) = try await request(url: endpoint.url, method: method.rawValue, headers: headers, body: body, responseType: T.self)
                if statusCode == 401 {
                    await appUserDefault.navManager?.goToLogin(showToastMessage: false, message: "")
                    completionHandler(.failure(.authenticationFailed))
                    return
                } else if 400..<410 ~= statusCode {
                    completionHandler(.failure(.customError(errorMessage ?? "")))
                    return
                }
                else {
                    guard let data else {
                        completionHandler(.failure(.customError("Data unwrapping failed")))
                        return
                    }
                    completionHandler(.success(data))
                }
            } catch let apiError as APIError {
                completionHandler(.failure(apiError))
            } catch {
                completionHandler(.failure(.customError("Unexpected error: \(error.localizedDescription)")))
            }
        }
    }
    
    // Get Api with CompletionHandler
    func postMultipartRequest<T: Decodable>(endpoint: EndPoint, requestParameter: [String: Any?], completionHandler: @escaping (Result<T, APIError>) -> Void) {
    
        var headers = [
            ContentType.accessToken.rawValue: endpoint.accessToken,
        ]
        let method :httpMethod = .post
        let boundary =  "Boundary-\(UUID().uuidString)"
        headers[ContentType.type.rawValue] = "multipart/form-data; boundary=\(boundary)"
        var bodyData: Data?
        do {
            bodyData = try createBody(parameters: requestParameter, boundary: boundary, mimeType: "image/jpeg/png/jpg/docx/doc/mp4/mov/movie")
        } catch {
            completionHandler(.failure(.customError("Unable to create multipart data body: \(error.localizedDescription)")))
        }
        Task {
            do {
                let (data, statusCode, errorMessage) = try await request(url: endpoint.url, method: method.rawValue, headers: headers, body: bodyData, responseType: T.self)
                if statusCode == 401 {
                    await appUserDefault.navManager?.goToLogin(showToastMessage: false, message: "")
                    completionHandler(.failure(.authenticationFailed))
                    return
                } else if 400..<410 ~= statusCode {
                    completionHandler(.failure(.customError(errorMessage ?? "")))
                    return
                }
                else {
                    guard let data else {
                        completionHandler(.failure(.customError("Data unwrapping failed")))
                        return
                    }
                    completionHandler(.success(data))
                }
            } catch let apiError as APIError {
                completionHandler(.failure(apiError))
            } catch {
                completionHandler(.failure(.customError("Unexpected error: \(error.localizedDescription)")))
            }
        }
    }
    
    //MARK:- Func for Create Body for multipart Api to append Video and images
    func createBody(parameters: [String: Any?], boundary: String, mimeType: String) throws -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        let fromData = "Content-Disposition: form-data"
        let nameKeyField = "name="
        let fileNameField = "filename="
        let type = "Content-Type"
        
        for (key, value) in parameters {
            if(value is String || value is NSString) {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(fromData); \(nameKeyField)\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value ?? "")\(lineBreak)")
            } else if let imagValue = value as? UIImage {
                let r = arc4random()
                let filename = "image\(r).jpg" //MARK:  put your imagename in key
                guard let data = imagValue.jpegData(compressionQuality: 0.5) else {
                    throw NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to Data"])
                }
                body.append("--\(boundary)\r\n")
                body.append("\(fromData); \(nameKeyField)\"\(key)\"; \(fileNameField)\"\(filename)\"\(lineBreak)")
                body.append("\(type): \(mimeType)\(lineBreak + lineBreak)")
                body.append(data)
                body.append("\(lineBreak)")
            }else if value is [String: String] {
                var body1 = Data()
                body.append("\(fromData); \(nameKeyField)\"\(key)\"\(lineBreak + lineBreak)")
                for (keyy, valuee) in (value as? [String: String])! {
                    body1.append("--\(boundary)\r\n")
                    body1.append("\(fromData); \(nameKeyField)\"\(keyy)\"\(lineBreak + lineBreak)")
                    body1.append("\(valuee)\(lineBreak)")
                }
                body.append(body1)
            } else if let dataValue = value as? URL {
                let r = arc4random()
                let filename = "\(r).pdf" //MARK:  put your imagename in key
                let data: Data = try Data(contentsOf: dataValue)
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(fromData); \(nameKeyField)\"\(key)\"; \(fileNameField)\"\(filename)\"\(lineBreak)")
                body.append("\(type): \(mimeType)\(lineBreak + lineBreak)")
                body.append(data)
                body.append("\(lineBreak)")
                
            } else if let images = value as? [UIImage] {
                for image in images {
                    let r = arc4random()
                    let filename = "image\(r).jpg" //MARK:  put your imagename in key
                    guard let data = image.jpegData(compressionQuality: 0.5) else {
                        throw NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to Data"])
                    }
                    body.append("--\(boundary)\(lineBreak)")
                    body.append("\(fromData); \(nameKeyField)\"\(key)\"; \(fileNameField)\"\(filename)\"\(lineBreak)")
                    body.append("\(type): \(mimeType)\(lineBreak + lineBreak)")
                    body.append(data)
                    body.append("\(lineBreak)")
                }
            }else if let videoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let r = arc4random()
                let filename = "\(key)\(r).mov" //MARK:  Put you image Name in key
                let data : Data = videoData
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(fromData); \(nameKeyField)\"\(key)\"; \(fileNameField)\"\(filename)\"\(lineBreak)")
                body.append("\(type): \(mimeType)\(lineBreak + lineBreak)")
                body.append(data)
                body.append("\(lineBreak)")
            } else if let multipleData = value as? [Data] { //MARK:  It is used for Multiple Data to api
                for filedata in multipleData {
                    let r = arc4random()
                    let filename = "\(key)\(r).mov" //MARK:-  put your imagename in key
                    let data: Data = filedata
                    body.append("--\(boundary)\(lineBreak)")
                    body.append("\(fromData); \(nameKeyField)\"\(key)\"; \(fileNameField)\"\(filename)\"\(lineBreak)")
                    body.append("\(type): \(mimeType)\(lineBreak + lineBreak)")
                    body.append(data)
                    body.append("\(lineBreak)")
                }
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
}
