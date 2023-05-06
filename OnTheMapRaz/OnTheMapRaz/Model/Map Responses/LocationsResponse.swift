//
//  LocationsResponse.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import Foundation

struct LocationsResponse: Codable {
    let results: [Results]
}

struct Results: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double
    let longitude: Double
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
