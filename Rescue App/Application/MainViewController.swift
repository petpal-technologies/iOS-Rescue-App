//
//  MainViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/24/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON
import MessageUI


class MainTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, EmailDelegator {
    
    
    var posts = [PetPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PetPostTableViewCell.self, forCellReuseIdentifier: "PetPostCell")
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        posts.removeAll()
        // Fetch posts again on reload (definitely not the best way to do it)
        Alamofire.request("\(API_HOST)/api/getPosts").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let jsonObject:JSON = JSON(responseData.result.value!)
                
                if let resData = jsonObject["posts"].arrayObject {
                    for post in resData{
                        let J_post = JSON(post)
                        let location_desc = J_post["location_description"].string
                        let title = J_post["title"].string
                        _ = J_post["created"].string
                        _ = J_post["modified"].string
                        let long = J_post["long"].double
                        let lat = J_post["lat"].double
                        let post_uuid = J_post["id"].string
                        let image_path = J_post["image"].string
                        let description = J_post["description"].string
                        let status = J_post["status"].string
                        let created = J_post["created"].string
                        let pet_post = PetPost(title: title!, coordinates: CLLocation(latitude: lat!, longitude: long!), locationDescription: location_desc!, id: post_uuid!, image_path: image_path!, description: description!, status: status!, created: created!)
                        self.posts.append(pet_post)
                    }
                }
                if self.posts.count > 0 {
                    self.posts.reverse()
                    self.tableView.reloadData()
                }
            }
        }
        navigationItem.hidesBackButton = true
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PetPostCell") as! PetPostTableViewCell
        cell.delegate = self
        let post = posts[indexPath.row]
        cell.post = post
        cell.postImageView.download(imagePath: post.image_path)
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view
        if let destinationVC = segue.destination as? DetailViewController {
            let index = self.tableView.indexPathForSelectedRow
            let indexNumber = index?.row
            tableView.deselectRow(at: index!, animated: false)
            destinationVC.post = posts[indexNumber!]
        }
    }
    
    
    
    
    // MARK: Email for verification of progress.
    func email(postID dataobject: String) {
        let email = ["chris@myunikorn.com", "sgorthy@myunikorn.com"]
        let subject = "Verification of post with id: \(dataobject)"
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(email)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody("Thank you! \n\nBelow, add a description of how you cared for the animal and found it a place to stay so that we can verify it is completed. \n - Chris and Sri -", isHTML: false)
        self.present(mailComposerVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    

}



protocol EmailDelegator {
    func email(postID dataobject: String)
}








