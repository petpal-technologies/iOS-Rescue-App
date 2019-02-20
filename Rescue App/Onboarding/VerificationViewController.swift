//
//  VerificationViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/28/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var verified = false
    
    @IBAction func VerifyPhoneButton(_ sender: Any) {
        
        // Do some Twilio Magic to verify the code sent to this phone #
        if verified == true {
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
