//
//  UpdateStatusViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 3/15/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

class UpdateStatusViewController: UIViewController {

    @IBOutlet weak var changeStatusButton: UIButton!
    var post: PetPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post != nil {
            if post!.status == "completed" {
                changeStatusButton.titleLabel!.text = "This has been taken care of"
            } else {
                changeStatusButton.titleLabel!.text = "This has not been taken care of"
            }
        }
    }

    @IBAction func changeStatusAction(_ sender: Any) {
        if post?.status == "completed" {
            post?.status = "incomplete"
        } else {
            post?.status = "completed"
        }
       
        editPost(viewController: self, post: post!)
    }
}
