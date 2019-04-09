//
//  MapViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 3/1/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController {
    
    var postAnnotations = [PostMapAnnotation]()
    var posts = [PetPost]()
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidLoad() {
        
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
                        let description = J_post["description"].string
                        let post_uuid = J_post["id"].string
                        let image_path = J_post["image"].string
                        let status = J_post["status"].string
                        let created = J_post["created"].string
                        let post_annotation = PostMapAnnotation(title: title!, locationName: description!, coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
                        
                        let pet_post = PetPost(title: title!, coordinates: CLLocation(latitude: lat!, longitude: long!), locationDescription: location_desc!, id: post_uuid!, image_path: image_path!, description: description!, status: status!, created: created!)
                        self.postAnnotations.append(post_annotation)
                        self.posts.append(pet_post)
                    }
                }
            }
            self.mapView.addAnnotations(self.postAnnotations)
        }
        
        super.viewDidLoad()
        mapView.delegate = self

        let initialLocation = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        centerMapOnLocation(location: initialLocation)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
extension MapViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? PostMapAnnotation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
