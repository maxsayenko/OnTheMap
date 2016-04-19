//
//  Config.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/18/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation

struct Config {
    struct UdacityUrls {
        static let getSession = "https://www.udacity.com/api/session"
        static let getUser = "https://www.udacity.com/api/users/"
    }
    
    struct ParseUrls {
        static let getStudents = "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt"
        static let sendStudentInfo = "https://api.parse.com/1/classes/StudentLocation/"
    }
    
    struct ParseHeaders {
        static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
}