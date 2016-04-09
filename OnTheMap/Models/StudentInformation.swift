//
//  StudentData.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/30/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation

struct StudentInformation {
    var createdAt: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var mapString: String = ""
    var mediaURL: String = ""
    var objectId: String = ""
    var uniqueKey: String = ""
    var updatedAt: String = ""
    
    init (studentInfo: NSDictionary) {
        if let createdAt = studentInfo["createdAt"] as? String {
            self.createdAt = createdAt
        }
        if let firstName = studentInfo["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = studentInfo["lastName"] as? String {
            self.lastName = lastName
        }
        if let latitude = studentInfo["latitude"] as? Float {
            self.latitude = latitude
        }
        if let longitude = studentInfo["longitude"] as? Float {
            self.longitude = longitude
        }
        if let mapString = studentInfo["mapString"] as? String {
            self.mapString = mapString
        }
        if let mediaURL = studentInfo["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        if let objectId = studentInfo["objectId"] as? String {
            self.objectId = objectId
        }
        if let uniqueKey = studentInfo["uniqueKey"] as? String {
            self.uniqueKey = uniqueKey
        }
        if let updatedAt = studentInfo["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
    }
}