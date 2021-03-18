//
//  CommentViewModel.swift
//  WhatsApps
//
//  Created by Usama on 22/02/2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class CommentViewModel {
    
    var comment: CommentModel?
    init(commentModel: CommentModel){
        self.comment = commentModel
    }
    
    init(){
    }
}
