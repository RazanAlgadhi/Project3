//
//  LoginResponse.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
