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


class NewPetPostViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var shortDescriptionField: UITextField!
    @IBOutlet weak var locationDescriptionField: UITextField!
    @IBOutlet weak var detailDescriptionField: UITextView!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    var imageToSend: UIImage?
    
    var lat: Double = 0.0
    var long: Double = 0.0
    
    let locationManager = CLLocationManager()
    
    var imagePicker: UIImagePickerController!

    @IBAction func postButtonPressed(_ sender: Any) {
        
        let dateString = Date().iso8601   //  "2019-02-06T00:35:01.746Z"
        
        let parameters:Parameters = [
                "description": shortDescriptionField.text!,
                "created": dateString,
                "modified": dateString,
                "title": titleField.text!,
                "long": Float(long),
                "location_description": "This is a location description",
                "lat": Float(lat),
                "user_id": user_id
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
            to: "http://167.99.162.140/api/new_post",
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        debugPrint(response.result)
                        _ = self.navigationController?.popViewController(animated: true)

                    }
                case .failure(let encodingError):
                    print("encoding Error : \(encodingError)")
                }
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.shortDescriptionField.inputAccessoryView = toolbar
        self.locationDescriptionField.inputAccessoryView = toolbar
        self.detailDescriptionField.inputAccessoryView = toolbar
        self.locationDescriptionField.inputAccessoryView = toolbar

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationDescriptionLabel.text = "Your current coordinates are: \(locValue.latitude) \(locValue.longitude)"
        self.lat = locValue.latitude
        self.long = locValue.longitude
        
        locationManager.stopUpdatingLocation()
    }


}

