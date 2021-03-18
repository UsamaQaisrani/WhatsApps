//
//  CommentModel.swift
//  WhatsApps
//
//  Created by Usama on 22/02/2021.
//

import Foundation

class CommentModel : Codable {
    
    var imageURL: String?
    var userID: String?
    var commentID: String?
    var userName: String?
    var commentMessage: String?
    var commentTime: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL
        case userID
        case commentID
        case userName
        case commentMessage
        case commentTime
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        userID = try values.decodeIfPresent(String.self, forKey: .userID)
        commentID = try values.decodeIfPresent(String.self, forKey: .commentID)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        commentMessage = try values.decodeIfPresent(String.self, forKey: .commentMessage)
        commentTime = try values.decodeIfPresent(String.self, forKey: .commentTime)
    }
    
    init(imageURL: String, userID: String, commentID: String, userName: String, commentMessage: String, commentTime: String)
    {
        self.imageURL = imageURL
        self.userID = userID
        self.userName = userName
        self.commentID = commentID
        self.commentMessage = commentMessage
        self.commentTime = commentTime
    }
    
    init(){
    }
}
