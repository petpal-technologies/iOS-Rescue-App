//
//  PostMapAnnotation.swift
//  Rescue App
//
//  Created by Christopher Horton on 3/1/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import MapKit

class PostMapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    
    
    

}
