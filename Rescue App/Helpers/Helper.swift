//
//  Helper.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/3/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON


func showAlert(viewController: UIViewController, title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: { _ in
    }))
    viewController.present(alert, animated: true, completion: nil)
}

func navigateToGetStarted(viewController: UIViewController) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let vc = storyBoard.instantiateInitialViewController()
    viewController.present(vc!, animated: true, completion: nil)
}

func navigateToTabBar(viewController: UIViewController) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let tabbarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
    viewController.present(tabbarVC, animated:true, completion:nil)
}


func assignbackground(with image: UIImage, view:UIView){
    let background = image
    var imageView : UIImageView!
    imageView = UIImageView(frame: view.bounds)
    imageView.contentMode =  UIView.ContentMode.scaleAspectFill
    imageView.image = background
    imageView.center = view.center
    imageView.layer.opacity = 0.5
    view.addSubview(imageView)
    view.sendSubviewToBack(imageView)
}

func sendEmail(with subject: String, body: String, to: [String], viewController: UIViewController) {
    
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.setToRecipients(to)
    mailComposerVC.setSubject(subject)
    mailComposerVC.setMessageBody(body, isHTML: false)
    viewController.present(mailComposerVC, animated: true, completion: nil)
}

func sendReply(with post_id: String, text: String) {
    
    let headers = [
        // Fixes Alamofire bug with CSRF token needed
        "Cookie": ""
    ]
    let params = ["post_id": post_id, "text": text, "author_id":"606f17047dcad50ff43f3a52a24d31bd"] as [String:Any]
    Alamofire.request(API_HOST+"/comments/", method: .post, parameters: params, headers: headers).responseString
        { response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                print("Success")
            case 404:
                print(print())
            default:
                print("Failure")
            }
        case .failure(_):
            print("Failure")
        }
    }
}
