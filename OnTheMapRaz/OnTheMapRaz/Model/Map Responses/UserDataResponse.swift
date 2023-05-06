//
//  UserDataResponse.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import Foundation

struct UserDataResponse: Codable {
    let lastName: String
    let firstName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
    }
}
