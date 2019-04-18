//
//  NewPetPostViewController.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/8/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class NewPetPostViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationDescriptionField: UITextField!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    var imageToSend: UIImage?
    var addedID = ""
    let newPin = MKPointAnnotation()
    var lat: Double = 0.0
    var long: Double = 0.0
    
    let locationManager = CLLocationManager()
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        let dateString = Date().iso8601   //  "2019-02-06T00:35:01.746Z"
        
        if (titleField.text == nil || imageToSend == nil || locationDescriptionField.text == nil) {
            let alert = UIAlertController(title: "Missing Fields", message: "Please fill in all data fields, don't forget to take a picture :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        postButton.title = "Posting..."
        postButton.isEnabled = false
        let parameters:Parameters = [
                "created": dateString,
                "modified": dateString,
                "title": titleField.text!,
                "long": Float(long),
                "location_description": locationDescriptionField.text!,
                "lat": Float(lat),
                "user_id": user_id,
                "description": descriptionLabel.text!,
                "views": 0
        ]
        
        let headers = [
            // Fixes Alamofire bug with CSRF token needed
            "Cookie": ""
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let image = self.imageToSend {
                let imageData = image.jpegData(compressionQuality: 0.2)
                multipartFormData.append(imageData!, withName: "image", fileName: "photo.jpg", mimeType: "jpg/png")
            }
            
            for (key, value) in parameters {
                if value is String || value is Int || value is Float {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
        },
            to: "\(API_HOST)/api/new_post",
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { (responseData) -> Void in
                        if((responseData.result.value) != nil) {
                            let jsonObject:JSON = JSON(responseData.result.value!)
                            self.addedID = jsonObject["id"].stringValue
                            self.showSharingAlert()
                        }
                    }
                case .failure(let encodingError):
                    print("encoding Error : \(encodingError)")
                }
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        assignbackground(with: UIImage(named: "dolphin_hoop")!, view: self.view)
        self.mapView.layer.cornerRadius = 5
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // MARK: Show done button on keyboard
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.titleField.inputAccessoryView = toolbar
        self.locationDescriptionField.inputAccessoryView = toolbar
        self.descriptionLabel.inputAccessoryView = toolbar

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(tapGestureRecognizer)
        
        mapView.delegate = self
        
        descriptionLabel.layer.cornerRadius = 5
        
        //Drop pin on map
        
    }
    
    // MARK: Tap gesture recognizers
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        pinView?.animatesDrop = true
        return pinView
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if (newState == MKAnnotationView.DragState.ending) {
            let droppedAt = view.annotation?.coordinate
            self.lat = droppedAt?.latitude ?? 0.0
            self.long = droppedAt?.longitude ?? 0.0
        }
        
        if (newState == .canceling ){
            view.setDragState(.none, animated: true)
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
        
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
       
        locationManager.stopUpdatingLocation()
        
    }
    
    func showSharingAlert(){
        let refreshAlert = UIAlertController(title: "Share", message: "Sharing will help find a safe home quicker", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let link = API_HOST + "/post/" + self.addedID
            
            // set up activity view controller
            let textToShare = [ link ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No thanks", style: .cancel, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(refreshAlert, animated: true)
    }


}

