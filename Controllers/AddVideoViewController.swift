//
//  AddVideoViewController.swift
//  WhatsApps
//
//  Created by Usama on 12/02/2021.
//

import UIKit
import Firebase
import FirebaseStorage

class AddVideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    
    
    

}

extension AddVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBAction func addVideoButtonPressed(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as! URL
//        let videoURL = VideosModel(url: url)
        self.dismiss(animated: true, completion: nil)
        let uploadTask = Storage.storage().reference().child("Videos/Earth").putFile(from: url, metadata: nil)
    }
    
    
}
