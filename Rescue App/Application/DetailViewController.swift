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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = post?.title
        imageView.download(imagePath: (post?.image_path)!)
        locationCoordinatesLabel.text = "Location \(post?.coordinates.coordinate.latitude)!, \(post?.coordinates.coordinate.longitude)!"
        locationDescriptionLabel.text = post?.locationDescription
        descriptionLabel.text = post?.description
        
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
