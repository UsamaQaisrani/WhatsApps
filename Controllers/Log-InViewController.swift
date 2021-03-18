//
//  Log-InViewController.swift
//  WhatsApps
//
//  Created by Usama on 08/02/2021.
//

import UIKit
import FirebaseAuth
class logInViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loginEmailText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Class Properties
    
    
    // MARK: - Base Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial run.
        initialSetup()
    }
}

// MARK: - Class Methods
extension logInViewController {
    
    fileprivate func initialSetup() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationItem.title = "Log In"
        loginEmailText.layer.cornerRadius = 10
        loginEmailText.layer.masksToBounds = true
        loginEmailText.layer.borderWidth = 0.5
        loginPasswordText.layer.cornerRadius = 10
        loginPasswordText.layer.masksToBounds = true
        loginPasswordText.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        loginButton.layer.borderWidth = 0.5
    }
}

// MARK: - IBActions
extension logInViewController {
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let userData = UserInfo(email: loginEmailText.text!, password: loginPasswordText.text!)
        let userVM = UserViewModel(userData: userData)
        userVM.loginUser { _ in
            if let vc = self.storyboard?.instantiateViewController(identifier: "tabBarViewController") {
                UIApplication.shared.windows.first?.rootViewController = vc
            }
        }
    }
}
