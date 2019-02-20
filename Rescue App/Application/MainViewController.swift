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
        tableView.register(UINib.init(nibName: "PetPostTableViewCell", bundle: nil), forCellReuseIdentifier: "PetPostCell")

        // Do any additional setup after loading the view.
//
//        let post1 = PetPost(title: "Golden Retriever", description: "There's an adorable golden retriever who likes to hang out in between the restaurant and hotel on First Street", imageLink: "", uname_poster: "chris_horton", coordinates: CLLocation(latitude: CLLocationDegrees(exactly: 20.234)!, longitude: CLLocationDegrees(exactly: 20.234)!), locationDescription: "None")
//        let post2 = PetPost(title: "Red Rover", description: "Red Rover Red Rover come on over", imageLink: "", uname_poster: "chris_horton", coordinates: CLLocation(latitude: CLLocationDegrees(exactly: 20.234)!, longitude: CLLocationDegrees(exactly: 20.234)!), locationDescription: "None")
//
//        posts.append(post1)
//        posts.append(post2)
        
        Alamofire.request("http://167.99.162.140/api/getPosts").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar:JSON = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["posts"].arrayObject {
                    for post in resData{
                        let J_post = JSON(post)
                        let location_desc = J_post["location_description"].string
                        let image_link = J_post["image_link"].string
                        let title = J_post["title"].string
                        let created = J_post["created"].string
                        _ = J_post["modified"].string
                        let long = J_post["long"].double
                        let lat = J_post["lat"].double
                        let description = J_post["description"].string
                        let pet_post = PetPost(title: title!, description: description!, imageLink: image_link!, uname_poster: "", coordinates: CLLocation(latitude: lat!, longitude: long!), locationDescription: location_desc!)
                        self.posts.append(pet_post)
                    }
                }
                if self.posts.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }

        print(posts)
        tableView.reloadData()
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetPostCell", for: indexPath) as! PetPostTableViewCell
        
        let post = posts[indexPath.row]
        cell.titleLabel?.text = post.title
        cell.descriptionLabel?.text = post.description
        return cell
    }
    
    func getPosts(){
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
