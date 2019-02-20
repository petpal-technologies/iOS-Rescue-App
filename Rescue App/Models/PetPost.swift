//
//  PetPost.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/3/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

struct PetPost {
    
    var title: String
    var description: String
    var imageLink: String
    var coordinates: CLLocation
    var locationDescription: String
    var uname_poster: String
    
    init(title:String, description: String, imageLink:String, uname_poster:String, coordinates:CLLocation, locationDescription:String) {
        self.title = title
        self.description = description
        self.imageLink = imageLink
        self.uname_poster = uname_poster
        self.coordinates = coordinates
        self.locationDescription = locationDescription
    }
    
    func getImage(with path: String) -> UIImage {
        // fetch the image using link provided
        let image = UIImage()
        
        return image
    }
    
    
}
