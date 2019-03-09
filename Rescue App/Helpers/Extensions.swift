//
//  Extensions.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/19/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FBSDKLoginKit

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}
extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}
extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
extension UIImage {
    func getCropRatio() -> CGFloat{
        return CGFloat ( self.size.width / self.size.height )
    }
    
}
extension UIImageView {
    func download(imagePath:String) {
        if let url = URL(string: "\(API_HOST)\(imagePath)") {
            Alamofire.request(url).responseData { (response) in
                switch response.response?.statusCode ?? -1 {
                case 200:
                    if let data = response.data {
                        let _image = UIImage(data: data)!
                        self.image = _image
                    }
                case 404:
                    print("Debug 404 desc: \(response.debugDescription)")
                    self.image = UIImage(named: "placeholder")
                default:
                    print("Debug desc: \(response.debugDescription)")
                    self.image = UIImage(named: "placeholder")
                }
                
            }
        }
        
    }
}


extension NewPetPostViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        cameraImageView.image = selectedImage
        imageToSend = selectedImage
    }
}






// Bring these 2 together because they do the same thing
extension OnboardingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension LogInViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if ((error) != nil) {
            
        } else {
            if let accessToken = FBSDKAccessToken.current() {
                let req: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken.tokenString, version: nil, httpMethod: "GET")
                req.start(completionHandler: { (connection, result, error) -> Void in
                    if ((error) != nil) {
                        print("Error: \(error)")
                    } else {
                        if let email : NSString = (result! as AnyObject).value(forKey: "email") as? NSString {
                            self.userEmail = email as String
                            self.performSegue(withIdentifier: "toOnboarding", sender: self)
                        }
                    }
                })
                
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
}
