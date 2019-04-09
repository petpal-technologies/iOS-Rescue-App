//
//  DetailViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/21/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController, MKMapViewDelegate  {
    
    var post: PetPost?
    var replies = [Reply]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyField: UITextField!

    let pin = MKPointAnnotation()
    var lat = 0.0
    var long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _post = post {
            titleLabel.text = _post.title
            imageView.download(imagePath: (_post.image_path))
            titleLabel.text = _post.title
            
            imageView.download(imagePath: _post.image_path)
            
            lat = _post.coordinates.coordinate.latitude
            long = _post.coordinates.coordinate.longitude
            
            locationDescriptionLabel.text = _post.locationDescription
            mapView.delegate = self
            
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            //set region on the map
            mapView.setRegion(region, animated: true)
            
            
            self.pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            mapView.addAnnotation(self.pin)
            
            tableView.register(UINib(nibName: "RepliesTableViewCell", bundle: nil), forCellReuseIdentifier: "ReplyTableCell")
            tableView.delegate = self
            tableView.dataSource = self
            
            getComments()
            
            let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
            let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
            let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
            toolbar.setItems([flexSpace, doneBtn], animated: false)
            toolbar.sizeToFit()
            self.replyField.inputAccessoryView = toolbar
        }
    }
    
    func getComments(){
        replies.removeAll()
        if let _post = post {
            let params = ["post_id": _post.id] as [String:Any]
            Alamofire.request("\(API_HOST)/comments/", method:.get,parameters:params).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    
                    let jsonObject:JSON = JSON(responseData.result.value!)
                    
                    if let resData = jsonObject["comments"].arrayObject {
                        for comment in resData {
                            let comment = JSON(comment)
                            let text = comment["text"].string
                            let created_date = comment["created_date"].string
                            let user_name = comment["author_name"].string
                            let reply = Reply(text: text!, date: created_date!, user_name: user_name!)
                            self.replies.append(reply)
                        }
                        self.replies = self.replies.reversed()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func replyButtonPressed(_ sender: Any) {
        if replyField.text != nil {
            if let _post = post {
                sendReply(with: _post.id, text: replyField.text!)
                replyField.text = ""
                getComments()
            }
        } else {
            showAlert(viewController: self, title: "Please enter a reply", message: "")
        }
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let link = API_HOST + "/post/" + (post?.id)!
        
        // set up activity view controller
        let textToShare = [ link ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChangeStatus" {
            let newVC = UpdateStatusViewController()
            newVC.post = self.post
        }
        
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReplyTableCell") as! RepliesTableViewCell
        
        cell.body.text = replies[indexPath.row].text
        cell.poster.text = replies[indexPath.row].user_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
