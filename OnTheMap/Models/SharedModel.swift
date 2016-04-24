//
//  SharedModel.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/8/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation

struct SharedModel {
    var students: [StudentInformation]?
    var user: UdacityUser?
    var isFacebook: Bool = false
    
    static var sharedInstance = SharedModel()
}
