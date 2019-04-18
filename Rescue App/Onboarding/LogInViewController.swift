//
//  ViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/21/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class LogInViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    @IBOutlet weak var EmailButton: UIButton!
    var userEmail = ""

    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController(title: "Incomplete Information", message: "Please enter your email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)

        } else {
            let user = User(id: emailTextField.text!, username: emailTextField.text!)
            login(viewController: self, username: user.username, password: passwordTextField.text!)
        }
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground(with: UIImage(named: "assorted_animals-1")!, view: self.view)
        
        facebookLogin.layer.cornerRadius = 15
        facebookLogin.clipsToBounds = true
        
        EmailButton.layer.cornerRadius = 15
        EmailButton.clipsToBounds = true
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.emailTextField.inputAccessoryView = toolbar
        self.passwordTextField.inputAccessoryView = toolbar
        self.facebookLogin.delegate = self
        self.facebookLogin.readPermissions = ["email","public_profile"]
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            let user = User(id: emailTextField.text!, username: emailTextField.text!)
            login(viewController: self, username: user.username, password: passwordTextField.text!)
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Note: FBSDK Handlers are in Extensions.swift
        
        //Let's validate a username to check if user actually needs to go through ob
        if validateUsername(username: userEmail, viewController: self) {
            fbLogin(username: userEmail)
        } else {
            if segue.identifier == "toOnboarding"{
                let newVC = segue.destination as! FacebookOnboardingViewController
                newVC.email = self.userEmail
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
