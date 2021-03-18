//
//  userModel.swift
//  WhatsApps
//
//  Created by Usama on 08/02/2021.
//

import Foundation

class UserInfo: Codable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var url: String?
    var imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case url
        case imageURL
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
    }
    
    init(id: String, firstName: String, lastName: String, email: String, password: String, url: String, imageURL: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.url = url
        self.imageURL = imageURL
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    init() {
    }
}
