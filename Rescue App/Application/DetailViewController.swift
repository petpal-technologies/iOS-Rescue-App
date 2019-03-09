//
//  DetailViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/21/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var post: PetPost?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationCoordinatesLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let link = API_HOST + "/post/" + (post?.id)!
        
        // set up activity view controller
        let textToShare = [ link ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let _post = post {
            titleLabel.text = _post.title
            imageView.download(imagePath: (_post.image_path))
            titleLabel.text = _post.title
        
            imageView.download(imagePath: _post.image_path)
        
            let latitude = _post.coordinates.coordinate.latitude
            let longitude = _post.coordinates.coordinate.longitude
            locationCoordinatesLabel.text = "Location \(latitude), \(longitude)"
            locationDescriptionLabel.text = _post.locationDescription
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
