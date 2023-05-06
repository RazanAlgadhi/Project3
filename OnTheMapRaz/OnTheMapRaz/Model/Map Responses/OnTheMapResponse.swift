//
//  OnTheMapResponse.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import Foundation

struct OnTheMapResponse: Codable {
    let status: Int
    let error: String
}

extension OnTheMapResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
