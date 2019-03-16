//
//  DetailViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/21/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    var post: PetPost?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    let pin = MKPointAnnotation()


    var lat = 0.0
    var long = 0.0
    
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
        
        if let _post = post {
            titleLabel.text = _post.title
            imageView.download(imagePath: (_post.image_path))
            titleLabel.text = _post.title
        
            imageView.download(imagePath: _post.image_path)
        
            lat = _post.coordinates.coordinate.latitude
            long = _post.coordinates.coordinate.longitude
            
            locationDescriptionLabel.text = _post.locationDescription
            mapView.delegate = self
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toChangeStatus" {
            let newVC = UpdateStatusViewController()
            newVC.post = self.post
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.lat = center.latitude
        self.long = center.longitude
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        pin.coordinate = location.coordinate
        mapView.addAnnotation(pin)
            
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        else {
            pinView?.annotation = annotation
        }
        
        pinView?.animatesDrop = true
        return pinView
    }


}
