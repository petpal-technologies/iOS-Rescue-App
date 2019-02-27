//
//  GetStartedViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/25/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class GetStartedViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        // HOW DO I CHECK IF THE USER IS LOGGED IN FFS
        
        if FBSDKAccessToken.current() != nil {
//            didLogin(viewController: self, userData: )
            if let appViewController = self.storyboard?.instantiateViewController(withIdentifier: "postsTableView") as? MainTableViewController{
                self.navigationController!.pushViewController(appViewController, animated: true)
            }
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
