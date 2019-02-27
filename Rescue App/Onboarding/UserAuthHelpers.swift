//
//  File.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/25/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

func login(viewController: UIViewController, username:String,password:String) {
    let params = ["username":username,"password":password] as [String:Any]
    Alamofire.request(API_HOST+"/auth/login",method:.post,parameters:params).responseData
        { response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                didLogin(viewController: viewController, userData: data)
            case 401:
                Helper.showAlert(viewController: viewController, title: "Oops", message: "Username or Password Incorrect")
            default:
                Helper.showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            Helper.showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
            }
    }
}

func didLogin(viewController: UIViewController, userData:Data) {
    do {
        //decode data into user object
        User.current = try JSONDecoder().decode(User.self, from: userData)
        user_id = User.current.id
        
        viewController.view.endEditing(false)
                
        if let appViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "postsTableView") as? MainTableViewController{
            viewController.navigationController!.pushViewController(appViewController, animated: true)
        }
    } catch {
        Helper.showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
    }
}


func signUp(viewController: UIViewController, username:String,password:String) {
    let params = ["username":username,"password":password] as [String:Any]
    Alamofire.request(API_HOST+"/auth/signup",method:.post,parameters:params).responseData
        { response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                do {
                    User.current = try JSONDecoder().decode(User.self, from: data)
                    user_id = User.current.id
                    if let appViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "postsTableView") as? MainTableViewController{
                        viewController.navigationController!
                        viewController.navigationController!.pushViewController(appViewController, animated: true)
                    }
                } catch {
                    Helper.showAlert(viewController: viewController, title: "Oops!",message: error.localizedDescription)
                }
            case 401:
                Helper.showAlert(viewController: viewController, title: "Oops", message: "Username Taken")
            default:
                Helper.showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            Helper.showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
            }
    }
}
