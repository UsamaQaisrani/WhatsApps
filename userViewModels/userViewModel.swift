//
//  userViewModel.swift
//  WhatsApps
//
//  Created by Usama on 08/02/2021.
//

import Foundation
import FirebaseAuth
import Firebase
import CodableFirebase
import FirebaseStorage

class UserViewModel {
    
    //MARK:- Class Properties
    var user: UserInfo?
    
    init(userData: UserInfo) {
        self.user = userData
    }
    init(){
    }

    //MARK: - Methods
    func loginUser(completion: @escaping (Bool) -> Void) {
        if let user = user {
            NetworkManager.shared.loginWithEmail(userModel: user) { _ in
                completion(true)
            }
        }
    }
    
    func signUpUser(completion: @escaping (Bool) -> Void){
        if let user = user {
            NetworkManager.shared.signUpWithEmail(userModel: user){ _ in
            completion(true)
            }
        }
    }
    
    func logOutUser(completion: @escaping (Bool)->Void){
        NetworkManager.shared.logOut { (response) in
            if response == true {
                completion(true)
            }
        }
    }
    
    func getUserDataFromFirebase(completion: @escaping ([UserInfo])->Void){
        NetworkManager.shared.getUserInfo { (userData) in
            MManager.shared.homeUser = userData
            completion(userData)
        }
    }
}
