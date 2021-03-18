//
//  VideosModel.swift
//  VideosApp
//
//  Created by Usama on 11/02/2021.
//


import Foundation

class VideosModel : Codable {
    
    var id: String?
    var url: String?
    var userID: String?
    var likesCount: Int?
    var likedVideoCheck: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case userID
        case likesCount
        case likedVideoCheck
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        userID = try values.decodeIfPresent(String.self, forKey: .userID)
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount)
        likedVideoCheck = try values.decodeIfPresent(Bool.self, forKey: .likedVideoCheck)
    }
    
    init(id: String, url: String){
        self.id = id
        self.url = url
        
    }
    init(id: String, url: String, userID: String, likesCount: Int){
        self.id = id
        self.url = url
        self.userID = userID
        self.likesCount = likesCount
    }
    
    init(url: String) {
        self.url = url
    }
    
    init(id: String){
        self.id = id
    }
    
    init(likesCount: Int){
        self.likesCount = likesCount
    }
    
    init(id: String, likedVideoCheck: Bool){
        self.id = id
        self.likedVideoCheck = likedVideoCheck
    }
    
    init(){
    }
}
