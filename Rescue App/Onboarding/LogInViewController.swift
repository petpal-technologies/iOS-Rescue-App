//
//  ViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/21/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var FacebookLogin: UIButton!
    
    @IBOutlet weak var EmailButton: UIButton!
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController(title: "Incomplete Information", message: "Please enter your email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)

        }
        let user = User(id: emailTextField.text!, username: emailTextField.text!)
        login(username: user.username, password: passwordTextField.text!)
        
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FacebookLogin.layer.cornerRadius = 20
        FacebookLogin.clipsToBounds = true
        
        EmailButton.layer.cornerRadius = 20
        EmailButton.clipsToBounds = true
        
        if let data = UserDefaults.standard.data(forKey: "user") {
            didLogin(userData: data)
        }
        
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
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            //change cursor from username to password textfield
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            //attempt to login when we press enter on password field
            let user = User(id: emailTextField.text!, username: emailTextField.text!)
            
            login(username: user.username, password: passwordTextField.text!)
        }
        return true
    }
    
    func login(username:String,password:String) {
        let params = ["username":username,"password":password] as [String:Any]
        Alamofire.request(API_HOST+"/auth/login",method:.post,parameters:params).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    self.didLogin(userData: data)
                case 401:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Username or Password Incorrect")
                default:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
                }
            case .failure(let error):
                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                }
        }
    }
    
    func didLogin(userData:Data) {
        do {
            //decode data into user object
            User.current = try JSONDecoder().decode(User.self, from: userData)
            user_id = User.current.id
            
            emailTextField.text = ""
            passwordTextField.text = ""
            self.view.endEditing(false)
            self.performSegue(withIdentifier: "toApp", sender: nil)
        } catch {
            Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
        }
    }
    
}
