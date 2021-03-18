//
//  LaunchViewController.swift
//  WhatsApps
//
//  Created by Usama on 24/02/2021.
//

import UIKit

class LaunchViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK:- Base Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

}
//MARK:- Class Methods

extension LaunchViewController {
    
    fileprivate func initialSetup(){
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 0.5
        loginButton.layer.borderWidth = 0.5
        signUpButton.layer.masksToBounds = true
        loginButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
//MARK:- IBActions
    
extension LaunchViewController{
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let vc =  storyboard?.instantiateViewController(identifier: "loginViewController") as! logInViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "signupStoryBoard") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
