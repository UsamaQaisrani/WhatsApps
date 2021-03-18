//
//  VideoViewModel.swift
//  VideosApp
//
//  Created by Usama on 11/02/2021.
//

import Foundation
import Firebase
import FirebaseStorage

class VideoViewModel {
        
    var video: VideosModel?
    var comment: CommentModel?
    init(commentModel: CommentModel){
        self.comment = commentModel
    }
    init (videoURL: VideosModel){
        self.video = videoURL
    }
    init(){
    }
    
    func getURL(completion: @escaping (String) -> Void){
        NetworkManager.shared.upload(video: video!)
        }
    
    
    func getVideoDownloadURL(completion: @escaping ([VideosModel])->Void){
        NetworkManager.shared.downloadVideos() { videoData in
            MManager.shared.profileVideosArray = videoData
            completion(videoData)
        }
}
    func getHomeVideos(completion: @escaping ([VideosModel])->Void){
        NetworkManager.shared.downloadHomeVideos { (videoData) in
            MManager.shared.homeVideosArray = videoData
            completion(videoData)
        }
    }
    
    func updataLikesCount(videoID: String, likesCount: Int, isLiked: Bool, completion: @escaping (Bool)-> Void){
        NetworkManager.shared.updateLikesCount(videoID: videoID, likesCount: likesCount, isLiked: isLiked) { (bool) in
            if bool == true {
                completion(true)
            }
        }
    }
    
    func myLikedVideos(videoID: String){
        NetworkManager.shared.myLikedVideos(videoID: videoID)
    }
    
    func likedVideoCheck(completion: @escaping ([VideosModel])->Void){
        NetworkManager.shared.checkIfLiked { (likedVideosArray) in
            MManager.shared.homeLikedVideosArray = likedVideosArray
            completion(likedVideosArray)
        }
    }
    
    func profileLikedVideoCheck(completion: @escaping([VideosModel])->Void){
        NetworkManager.shared.checkIfLiked { (likedVideosArray) in
            MManager.shared.profileLikedVideosArray = likedVideosArray
            completion(likedVideosArray)
        }
    }
    
    func getInfoForComment(completion: @escaping (UserInfo)->Void){
        NetworkManager.shared.getUserData { (commentInfo) in
            completion(commentInfo)
        }
    }
    
    func postComment(videoID: String){
        NetworkManager.shared.postComment(comment: comment ?? CommentModel(), videoID: videoID)
    }
    
    func getCommentsFromFirebase(videoID: String, completion: @escaping ([CommentModel])->Void){
        NetworkManager.shared.getComments(videoID: videoID) { (commentsArray) in
            completion(commentsArray)
        }
    }
    
    func getuserData(completion: @escaping (UserInfo)->Void){
        
        NetworkManager.shared.getUserInfo { (userInfo) in
            userInfo.forEach { (userInfo) in
                if Auth.auth().currentUser?.uid == userInfo.id {
                    let userData = userInfo
                    completion(userData)
                    
                }
            }
        }
        
    }
}
