//
//  SettingsTableViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 3/4/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class SettingsTableViewController: UITableViewController {

    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        if FBSDKAccessToken.current() != nil {
            FBSDKAccessToken.setCurrent(nil)
        }
        signOut(viewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func sendFeedbackButton(_ sender: Any) {
        let email = "chris@myunikorn.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


}
