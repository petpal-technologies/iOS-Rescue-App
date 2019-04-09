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
import FBSDKLoginKit
import FBSDKCoreKit

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
        
        UserDefaults.standard.set(user_id, forKey: "user_id")
        UserDefaults.standard.set(User.current.username, forKey: "user_name")
        // when log out just clear this token.
//        UserDefaults.standard.string(forKey: "user_id")
//        UserDefaults.standard.object(forKey: "current_user")
        
        viewController.view.endEditing(false)
        navigateToTabBar(viewController: viewController)
    } catch {
        showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
    }
}


func signUp(viewController: UIViewController, username:String,password:String, user_name: String) {
    let params = ["username":username,"password":password, "user_name":user_name] as [String:Any]
    Alamofire.request(API_HOST+"/auth/signup",method:.post,parameters:params).responseData
        { response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                do {
                    User.current = try JSONDecoder().decode(User.self, from: data)
                    user_id = User.current.id
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    UserDefaults.standard.set(user_name, forKey: "user_name")
                    navigateToTabBar(viewController: viewController)
                } catch {
                    showAlert(viewController: viewController, title: "Oops!",message: error.localizedDescription)
                }
            case 401:
                showAlert(viewController: viewController, title: "Oops", message: "Email in use")
            default:
                showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
        }
    }
}

func signOut(viewController: UIViewController) {
    
    if FBSDKAccessToken.current() != nil {
        FBSDKAccessToken.setCurrent(nil)
    }
    
    let params = [:] as [String:Any]
    Alamofire.request(API_HOST+"/auth/logout",method:.post,parameters:params).responseData {
        response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                UserDefaults.standard.set(nil, forKey: "user_id")
                navigateToGetStarted(viewController: viewController)
            default:
                showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
        }
    }
}


func editPost(viewController: UIViewController, post: PetPost) {
    
    let params = ["title":post.title, "lat": post.coordinates.coordinate.latitude, "long": post.coordinates.coordinate.longitude, "location_description": post.locationDescription, "id": post.id, "description": post.description, "status": post.status] as [String:Any]
    // Need to upload image also.
    
    Alamofire.request(API_HOST+"/api/editPost",method:.post,parameters:params).responseData {
        response in switch response.result {
        case .success(let data):
            switch response.response?.statusCode ?? -1 {
            case 200:
                navigateToTabBar(viewController: viewController)
            default:
                showAlert(viewController: viewController, title: "Oops", message: "Unexpected Error")
            }
        case .failure(let error):
            showAlert(viewController: viewController,title: "Oops!",message: error.localizedDescription)
        }
    }
}
