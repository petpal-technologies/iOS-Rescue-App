//
//  Extensions.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/19/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}
extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}
extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
extension UIImage {
    func getCropRatio() -> CGFloat{
        return CGFloat ( self.size.width / self.size.height )
    }
    
}
extension UIImageView {
    func download(imagePath:String) {
        if let url = URL(string: "http://167.99.162.140\(imagePath)") {
            Alamofire.request(url).responseData { (response) in
                switch response.response?.statusCode ?? -1 {
                case 200:
                    if let data = response.data {
                        let _image = UIImage(data: data)!
                        self.image = _image
                    }
                case 404:
                    print("Debug 404 desc: \(response.debugDescription)")
                    self.image = UIImage(named: "placeholder")
                default:
                    print("Debug desc: \(response.debugDescription)")
                    self.image = UIImage(named: "placeholder")
                }
                
            }
        }
        
    }
}


extension NewPetPostViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        cameraImageView.image = selectedImage
        imageToSend = selectedImage
    }
}
