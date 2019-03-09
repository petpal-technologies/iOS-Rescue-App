//
//  Helper.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/3/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

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
    imageView.clipsToBounds = true
    imageView.image = background
    imageView.center = view.center
    imageView.layer.opacity = 0.5
    view.addSubview(imageView)
    view.sendSubviewToBack(imageView)
}
