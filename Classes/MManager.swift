//
//  MManager.swift
//  VideosApp
//
//  Created by Usama on 17/02/2021.
//

import Firebase
import FirebaseAuth
import FirebaseStorage

class MManager {
    
    //MARK:- Class Properties
    var homeVideosArray: [VideosModel]?
    var profileVideosArray: [VideosModel]?
    var homeLikedVideosArray: [VideosModel]?
    var profileLikedVideosArray: [VideosModel]?
    var homeUser: [UserInfo]?
    var profileUser: UserInfo?

    static let shared = MManager()
    
}
