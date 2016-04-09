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

//createdAt = "2016-04-02T23:21:01.536Z";
//firstName = Denis;
//lastName = Ricard;
//latitude = "48.8567879";
//longitude = "2.3510768";
//mapString = "Paris, France";
//mediaURL = "https://udacity.com";
//objectId = 1Wmk4Td6OY;
//uniqueKey = 5069059522;
//updatedAt = "2016-04-02T23:21:01.536Z";