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
                showAlert(viewController: viewController, title: "Oops", message: "Username or Password Incorrect")
            default:
                showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
            }
    }
}

func didLogin(viewController: UIViewController, userData:Data) {
    do {
        //decode data into user object
        User.current = try JSONDecoder().decode(User.self, from: userData)
        user_id = User.current.id
        
        viewController.view.endEditing(false)
        navigateToTabBar(viewController: viewController)
    } catch {
        showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
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
                    navigateToTabBar(viewController: viewController)
                } catch {
                    showAlert(viewController: viewController, title: "Oops!",message: error.localizedDescription)
                }
            case 401:
                showAlert(viewController: viewController, title: "Oops", message: "Username Taken")
            default:
                showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
            }
    }
}

func signOut(viewController: UIViewController) {
    let params = [:] as [String:Any]
    
    Alamofire.request(API_HOST+"/auth/logout",method:.post,parameters:params).responseData {
        response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                navigateToGetStarted(viewController: viewController)
            default:
                showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
        }
    }
    
}
