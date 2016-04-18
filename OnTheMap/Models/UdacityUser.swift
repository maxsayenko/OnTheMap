//
//  UdacityUserModel.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/8/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

struct UdacityUser {
    let userId: String
    let sessionExpiration: String
    let sessionId: String
    var firstName: String? = ""
    var lastName: String? = ""
    var postedLocationId: String? = ""
    
    init(userId: String, sessionExpiration: String, sessionId: String) {
        self.userId = userId
        self.sessionExpiration = sessionExpiration
        self.sessionId = sessionId
    }
}
