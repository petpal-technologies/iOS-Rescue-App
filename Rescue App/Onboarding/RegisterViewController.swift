//
//  RegisterViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/3/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var typesOfPeople = [String]()
    
    @IBOutlet weak var typesOfPeoplePicker: UIPickerView!
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typesOfPeople.append("A good citizen")
        typesOfPeople.append("An animal activist")
        typesOfPeople.append("A veterinarian")
        typesOfPeople.append("A PETA member")
        typesOfPeoplePicker.delegate = self
        typesOfPeoplePicker.dataSource = self
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.emailField.inputAccessoryView = toolbar
        self.passwordField.inputAccessoryView = toolbar
        self.confirmPassword.inputAccessoryView = toolbar
        self.usernameField.inputAccessoryView = toolbar
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            signUp(viewController: self, username: emailField.text!, password: passwordField.text!, user_name: usernameField.text!, fb_user: false)
        }
        return true
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if passwordField.text == confirmPassword.text && emailField.text != "" && passwordField.text != "" && usernameField.text != "" {
            signUp(viewController: self, username: emailField.text!, password: passwordField.text!, user_name: usernameField.text!, fb_user: false )
        }
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
