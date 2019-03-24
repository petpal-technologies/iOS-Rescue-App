//
//  Reply.swift
//  Rescue App
//
//  Created by Christopher Horton on 3/23/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import Foundation

struct Reply {
    var text: String
    var created_date: String
    
    init(text: String, date: String) {
        self.text = text
        self.created_date = date
    }
}
