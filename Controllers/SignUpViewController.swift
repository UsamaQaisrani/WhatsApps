//
//  ViewController.swift
//  WhatsApps
//
//  Created by Usama on 08/02/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var signUpImageView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK: - Class Properties
    var imagePicker: ImagePicker!
    var userImage : UIImage?
    var imageURL: String?
    var userInfo : UserInfo?
    
    //MARK: - Base Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}
//MARK: - Class Methods

extension SignUpViewController {
    fileprivate func initialSetup(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title = "Sign Up"
        signUpImageView.layer.cornerRadius = addImageButton.frame.height/2
        emailTextField.layer.cornerRadius = 10
        firstName.layer.cornerRadius = 10
        lastName.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        firstName.layer.masksToBounds = true
        lastName.layer.masksToBounds = true
        passwordTextField.layer.masksToBounds = true
        emailTextField.layer.borderWidth = 0.5
        firstName.layer.borderWidth = 0.5
        lastName.layer.borderWidth = 0.5
        passwordTextField.layer.borderWidth = 0.5
        signupButton.layer.cornerRadius = 10
        signupButton.layer.masksToBounds = true
        signupButton.layer.borderWidth = 0.5
    }
}

extension SignUpViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, imageUrl: String?) {
        self.imageView.image = image
        userImage = image
        self.imageURL = imageUrl
    }
    
}

//MARK: - IBActions
extension SignUpViewController {
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let userData = UserInfo(id: "", firstName: firstName.text!, lastName: lastName.text!, email: emailTextField.text!, password: passwordTextField.text!, url: imageURL ?? "", imageURL: "")
        let userVM = UserViewModel(userData: userData)
        userVM.signUpUser { _ in
            print("Account Created Successfully")
        }
    }
    
    @IBAction func addPhotoButtonClicked(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
}
