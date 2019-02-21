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
    }
    
    func signUp(username:String,password:String) {
        let params = ["username":username,"password":password] as [String:Any]
        Alamofire.request(API_HOST+"/auth/signup",method:.post,parameters:params).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    do {
                        User.current = try JSONDecoder().decode(User.self, from: data)
                        user_id = User.current.id
                        
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.performSegue(withIdentifier: "toApp", sender: nil)
                    } catch {
                        Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                    }
                case 401:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Username Taken")
                default:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
                }
            case .failure(let error):
                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            signUp(username: emailField.text!, password: passwordField.text!)
        }
        return true
    }
    
    @IBAction func registerAction(_ sender: Any) {
        signUp(username: emailField.text!, password: passwordField.text!)
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

// MARK: Fill picker with types of people and manage
extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = typesOfPeople[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesOfPeople[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesOfPeople.count
    }
    
}
