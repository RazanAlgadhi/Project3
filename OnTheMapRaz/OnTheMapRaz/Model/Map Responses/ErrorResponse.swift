//
//  ErrorResponse.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "error"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
