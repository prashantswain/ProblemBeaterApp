//
//  JsonRequestEncoding.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 30/05/25.
//
import Foundation

extension Encodable {
    func toJSONData(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateEncodingStrategy
        do {
            return try encoder.encode(self)
        } catch {
            print("❌ Failed to encode \(Self.self): \(error)")
            return nil
        }
    }
}
