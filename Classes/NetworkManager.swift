//
//  NetworkManager.swift
//  WhatsApps
//
//  Created by Usama on 10/02/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import CodableFirebase
import FirebaseFirestore

class NetworkManager {
    
    //MARK:- Class Properties
    static let shared = NetworkManager()
    let db = Firestore.firestore()
    var imageURL : String?
    
    //MARK:- Class Methods
    func signUpWithEmail(userModel: UserInfo, completion: @escaping (Bool) -> Void) {
        authenticateUserAccount(userModel: userModel) { (auth) in
            if auth == true{
                self.uploadImage(url: userModel.url ?? "") { (url) in
                    if !url.isEmpty {
                        self.createUserInformation(userModel: userModel, url: url)
                        completion(true)
                        return
                    }
                }
            }
        }
    }
    
    //Login With Email
    func loginWithEmail(userModel: UserInfo, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: userModel.email ?? "", password: userModel.password ?? "") { authResult, error in
            if let error = error {
                print("Unable To Login", error.localizedDescription)
                return
            }
            if Auth.auth().currentUser?.isEmailVerified ?? false {
                print("Login Successful")
                completion(true)
                return
            }
            print("Please verify your email first.")
        }
    }
    
    //UPLOAD IMAGE
    func uploadImage(url: String, completion: @escaping (String) -> Void) {
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("images/\(Auth.auth().currentUser!.uid)")
        if let url = URL(string: url) {
            riversRef.putFile(from: url, metadata: nil) { (response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                riversRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.imageURL = url?.absoluteString
                    completion(url?.absoluteString ?? "")
                }
            }
        }
    }
    
    //Authenticate User Account
    func authenticateUserAccount(userModel: UserInfo, completion: @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: userModel.email ?? "", password: userModel.password ?? "") { (auth, error) in
            if let error = error {
                print("Not Successful", error.localizedDescription)
                return
            }
            Auth.auth().currentUser?.sendEmailVerification(completion: nil)
            completion(true)
        }
    }
    
    func createUserInformation(userModel: UserInfo, url: String) {
        let userData = UserInfo(id: Auth.auth().currentUser!.uid, firstName: userModel.firstName ?? "", lastName: userModel.lastName ?? "", email: userModel.email ?? "", password: userModel.password ?? "", url: url, imageURL: imageURL ?? "")
        let docData = try! FirestoreEncoder().encode(userData)
        self.db.collection("Users").document("\(Auth.auth().currentUser!.uid)").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                print("Document successfully written!")
            }
        }
    }
    
    func upload(video: VideosModel){
        uploadVideo(video: video) { (urlString) in
            if !(urlString.url?.isEmpty ?? false) {
                self.uploadURL(videoURL: urlString)
            }
        }
    }
    
    func uploadVideo(video: VideosModel, completion: @escaping (VideosModel) -> Void) {
        let docID = db.collection("Videos").document().documentID
        if let url = URL(string: video.url ?? "") {
            let storageRef = Storage.storage().reference()
            let riversRef = storageRef.child("Videos/\(docID)")
            riversRef.putFile(from: url, metadata: nil) { (response, error) in
                guard response != nil else {
                    print(error!.localizedDescription)
                    return
                }
                riversRef.downloadURL { (urlString, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    let videoURL = VideosModel(url: urlString?.absoluteString ?? "")
                    completion(videoURL)
                }
            }
        }
    }
    
    func uploadURL(videoURL: VideosModel){
        let docID = db.collection("Videos").document().documentID
        //        VideosModel(id: docID)
        let videoData = VideosModel(id: "\(docID)", url: videoURL.url ?? "", userID: Auth.auth().currentUser!.uid, likesCount: 0)
        let docData = try! FirestoreEncoder().encode(videoData)
        self.db.collection("Videos").document("\(docID)").setData(docData) { error in
            if let error = error {
                print("Error Saving URL", error.localizedDescription)
            }
            else {
                print("URL Saved Successfully")
            }
        }
    }
    
    func downloadVideos(completion : @escaping ([VideosModel]) -> Void) {
        var videosArray = [VideosModel]()
        db.collection("Videos").whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, err)  in
                for document in querySnapshot!.documents {
                    let decodedData = try! FirestoreDecoder().decode(VideosModel.self, from: document.data())
                    videosArray.append(decodedData)
                }
                completion(videosArray)
            }
    }
    
    func downloadHomeVideos(completion: @escaping ([VideosModel])-> Void){
        var videosArray = [VideosModel]()
        db.collection("Videos").whereField("userID", isNotEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                let decodedData = try! FirestoreDecoder().decode(VideosModel.self, from: document.data())
                videosArray.append(decodedData)
            }
            completion(videosArray)
        }
    }
    
    func updateLikesCount(videoID: String, likesCount: Int, isLiked: Bool, completion: @escaping (Bool)-> Void){
        if isLiked == true {
            db.collection("Videos").document("\(videoID)").setData([ "likesCount": likesCount ], merge: true) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
                else {
                    self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "").collection("likedVideos").document(videoID).delete() {err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    completion(true)
                }
            }
        }
        else {
            db.collection("Videos").document("\(videoID)").setData([ "likesCount": likesCount ], merge: true) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
                else {
                    completion(true)
                }
            }
        }
    }
    
    func myLikedVideos(videoID: String){
        let videoData = VideosModel(id: videoID, likedVideoCheck: true)
        let decodedVideoData = try! FirestoreEncoder().encode(videoData)
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("Users").document(userID).collection("likedVideos").document("\(videoID)").setData(decodedVideoData)
        }
    }
    
    func checkIfLiked(completion: @escaping ([VideosModel])->Void){
        var likedVideosArray = [VideosModel]()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("Users").document(userID).collection("likedVideos").getDocuments{ (query, error) in
                for documents in query!.documents {
                    let decodedData = try! FirestoreDecoder().decode(VideosModel.self, from: documents.data())
                    likedVideosArray.append(decodedData)
                }
                completion(likedVideosArray)
            }
        }
    }
    
    func getUserData(completion: @escaping (UserInfo)->Void){
        db.collection("Users").document(Auth.auth().currentUser?.uid ?? "").getDocument { (document, error) in
            let decodedData = try! FirebaseDecoder().decode(UserInfo.self, from: document?.data() ?? "")
            let commentInfo = UserInfo(id: decodedData.id ?? "", firstName: decodedData.firstName ?? "", lastName: decodedData.lastName ?? "", email: decodedData.email ?? "", password: "", url: decodedData.url ?? "", imageURL: decodedData.imageURL ?? "")
            completion(commentInfo)
        }
    }
    
    func postComment(comment: CommentModel, videoID: String){
        let commentID = db.collection("Videos").document(videoID).collection("Comments").document().documentID
        let commentData = CommentModel(imageURL: comment.imageURL ?? "", userID: comment.userID ?? "", commentID: commentID, userName: comment.userName ?? "", commentMessage: comment.commentMessage ?? "", commentTime: comment.commentTime ?? "")
        let encodedData = try! FirebaseEncoder().encode(commentData)
        db.collection("Videos").document(videoID).collection("Comments").document(commentID).setData(encodedData as! [String : Any])
    }
    
    
    func getComments(videoID: String, completion: @escaping ([CommentModel])->Void){
        var commentsArray = [CommentModel]()
        db.collection("Videos").document(videoID).collection("Comments").getDocuments { (query, error) in
            for documents in query!.documents {
                let decodedData = try! FirestoreDecoder().decode(CommentModel.self, from: documents.data())
                commentsArray.append(decodedData)
            }
            completion(commentsArray)
        }
    }
    
    func logOut(completion: @escaping (Bool)->Void){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completion(false)
        }
        completion(true)
    }
    
    func getUserInfo(completion: @escaping ([UserInfo])->Void){
        var userData = [UserInfo]()
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let decodedData = try! FirestoreDecoder().decode(UserInfo.self, from: document.data())
                    if Auth.auth().currentUser?.uid == decodedData.id{
                        MManager.shared.profileUser = decodedData
                    }
                    userData.append(decodedData)
                }
            }
        }
        completion(userData)

    }
}
