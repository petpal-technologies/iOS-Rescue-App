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
    var coordinates: CLLocation
    var locationDescription: String
    var id: String
    var image_path: String
    var image: UIImage?
    
    init(title:String, description: String, coordinates:CLLocation, locationDescription:String, id: String, image_path: String) {
        self.title = title
        self.description = description
        self.coordinates = coordinates
        self.locationDescription = locationDescription
        self.id = id
        self.image_path = image_path
    }
    
    static func getImage(imagePath: String, completionHandler: @escaping (_ image: UIImage) -> ()) {
        var _image: UIImage = UIImage(named: "404-not-found")!
        let remoteImageURL = URL(string: "http://167.99.162.140\(imagePath)")!
        
        Alamofire.request(remoteImageURL).responseData { (response) in
            switch response.response?.statusCode ?? -1 {
            case 200:
                if let data = response.data {
                    _image = UIImage(data: data)!
                }
            case 404:
                print("Debug 404 desc: \(response.debugDescription)")
            default:
                print("Debug desc: \(response.debugDescription)")
            }
            completionHandler(_image)
        }
        
        
    }
    
    
}
