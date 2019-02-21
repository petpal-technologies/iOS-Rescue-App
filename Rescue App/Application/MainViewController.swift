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

class MainTableViewController: UITableViewController{
    var posts = [PetPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PetPostTableViewCell.self, forCellReuseIdentifier: "PetPostCell")
        
        Alamofire.request("http://167.99.162.140/api/getPosts").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar:JSON = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["posts"].arrayObject {
                    for post in resData{
                        let J_post = JSON(post)
                        let location_desc = J_post["location_description"].string
                        let title = J_post["title"].string
                        _ = J_post["created"].string
                        _ = J_post["modified"].string
                        let long = J_post["long"].double
                        let lat = J_post["lat"].double
                        let description = J_post["description"].string
                        let post_uuid = J_post["id"].string
                        let image_path = J_post["image"].string
                        let pet_post = PetPost(title: title!, description: description!, coordinates: CLLocation(latitude: lat!, longitude: long!), locationDescription: location_desc!, id: post_uuid!, image_path: image_path!)
                        self.posts.append(pet_post)
                    }
                }
                if self.posts.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PetPostCell") as! PetPostTableViewCell
        let post = posts[indexPath.row]
        cell.postTitle = post.title
        cell.postDescription = post.description
        cell.postImageView.download(imagePath: post.image_path)
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toDetail", sender: self)
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
        
}












