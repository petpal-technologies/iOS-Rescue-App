//
//  OnboardingViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/25/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    var typesOfPeople = [String]()
    var email: String?
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var typesOfPeoplePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typesOfPeople.append("A good citizen")
        typesOfPeople.append("An animal activist")
        typesOfPeople.append("A veterinarian")
        typesOfPeople.append("A PETA member")
        typesOfPeoplePicker.delegate = self
        typesOfPeoplePicker.dataSource = self
        // Do any additional setup after loading the view.
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.passwordField.inputAccessoryView = toolbar
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if email != nil && passwordField.text != nil {
            signUp(viewController: self, username: email!, password: passwordField.text!)
        }
        
        
    }
    
}

