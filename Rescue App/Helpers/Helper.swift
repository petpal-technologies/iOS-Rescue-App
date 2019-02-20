//
//  Helper.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/3/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit


class Helper {
    static func showAlert(viewController: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: { _ in
        }))
        viewController.present(alert, animated: true, completion: nil)
    }

}
