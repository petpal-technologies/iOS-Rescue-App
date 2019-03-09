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
    var coordinates: CLLocation
    var locationDescription: String
    var id: String
    var image_path: String
    var image = UIImage(named: "404-not-found")
    var description: String
    
    init(title:String, coordinates:CLLocation, locationDescription:String, id: String, image_path: String, description: String) {
        self.title = title
        self.locationDescription = locationDescription
        self.coordinates = coordinates
        self.id = id
        self.image_path = image_path
        self.description = description
    }
    
}
