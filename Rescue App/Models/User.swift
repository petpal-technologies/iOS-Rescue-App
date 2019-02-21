//
//  User.swift
//  Rescue App
//
//  Created by Christopher Horton on 2/3/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import Foundation

struct User:Codable {
    
    static var current:User!
    var id:String
    var username:String
}
