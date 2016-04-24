//
//  UdacityNetworkHelper.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/9/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//
import Foundation
import FBSDKLoginKit

struct UdacityNetworkHelper {
    static let EMPTY_EMAIL_PASSWORD = "Email and password are required"
    static let BAD_DATA = "Error in reading response"
    static let UNKNOWN_ERROR = "Something went wrong"
    static let MISSING_USERID = "User Id is missing"
    
    static func getUdacityUser(userId: String, completionHandler: (userInfo: (firstName: String, lastName: String)? , errorString: String?) -> Void) {
        guard (!userId.isEmpty) else {
            completionHandler(userInfo: nil, errorString: MISSING_USERID)
            return
        }
        
        let url = Config.UdacityUrls.getUser + userId
        Network.get(url) { (data, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                completionHandler(userInfo: nil, errorString: errorMessage)
                return
            }
            
            /* subset response data! */
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            var parsedData: AnyObject
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHandler(userInfo: nil, errorString: BAD_DATA)
                return
            }
            
            if let user = parsedData["user"] as? NSDictionary {
                if let firstName = user["first_name"] as? String,
                    let lastName = user["last_name"] as? String {
                        completionHandler(userInfo: (firstName, lastName), errorString: nil)
                }
            }
        }
    }
    
    static func getStudentsData(completionHandler: (students: [StudentInformation]?, errorString: String?) -> Void) {
        let headers = [
            "X-Parse-Application-Id" : Config.ParseHeaders.applicationId,
            "X-Parse-REST-API-Key" : Config.ParseHeaders.apiKey
        ]
        
        Network.get(Config.ParseUrls.getStudents, headers: headers) { (data, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                completionHandler(students: nil, errorString: errorMessage)
                return
            }
            
            var parsedData: NSDictionary = NSDictionary()
            if let newData = data as! NSData? {
                do {
                    parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                } catch {
                    completionHandler(students: nil, errorString: BAD_DATA)
                    return
                }
            }
            
            if let results = parsedData["results"] as! NSArray? {
                let students = results.map({ (studentData) -> StudentInformation in
                    return StudentInformation(studentInfo: studentData as! NSDictionary)
                })
                
                completionHandler(students: students, errorString: nil)
                return
            }
        }
    }
    
    static func sendStudentLocation(locationId: String?, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, long: Double, completionHandler: (objectId: String?, errorString: String?) -> Void) {
        
        let headers = [
            "X-Parse-Application-Id" : Config.ParseHeaders.applicationId,
            "X-Parse-REST-API-Key" : Config.ParseHeaders.apiKey,
            "Content-Type" : "application/json"
        ]
        
        let data = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        
        var url = Config.ParseUrls.sendStudentInfo
        var method = "POST"
        if let locationId = locationId {
            url = Config.ParseUrls.sendStudentInfo + locationId
            method = "PUT"
        }
        
        Network.request(url, headers: headers, method: method, data: data) { (data, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                completionHandler(objectId: nil, errorString: errorMessage)
                return
            }
            
            var parsedData: NSDictionary = NSDictionary()
            if let newData = data as! NSData? {
                do {
                    parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                } catch {
                    completionHandler(objectId: nil, errorString: BAD_DATA)
                    return
                }
            }
            
            // Got error response from Udacity. Terminate.
            if let error = parsedData["error"] as? String {
                completionHandler(objectId: nil, errorString: error)
                return
            }
            
            if let locationId = locationId {
                completionHandler(objectId: locationId, errorString: nil)
                return
            }
            
            if let objectId = parsedData["objectId"] as! String? {
                completionHandler(objectId: objectId, errorString: nil)
                return
            }
        }
    }
    
    static func logoutUdacity(completionHandler: (isSuccessful: Bool, errorString: String?) -> Void) {
        // Facebook Logout flow
        if(SharedModel.sharedInstance.isFacebook) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        var headers: [String: String] = [String: String]()
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        Network.delete(Config.UdacityUrls.getSession, headers: headers) { (data, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                completionHandler(isSuccessful: false, errorString: errorMessage)
                return
            }
            
            /* subset response data! */
            _ = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            completionHandler(isSuccessful: true, errorString: nil)
        }
    }
}


extension UdacityNetworkHelper {
    static func getUdacitySession(email: String, password: String, completionHandler: (user: UdacityUser?, errorString: String?) -> Void) {
        guard (!email.isEmpty && !password.isEmpty) else {
            completionHandler(user: nil, errorString: EMPTY_EMAIL_PASSWORD)
            return
        }
        
        let data = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        Network.post(Config.UdacityUrls.getSession, headers: headers, data: data) { data, errorString in
            if let errorMessage = errorString where errorString != nil {
                completionHandler(user: nil, errorString: errorMessage)
                return
            }
            
            /* subset response data! */
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            var parsedData: AnyObject
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHandler(user: nil, errorString: BAD_DATA)
                return
            }
            
            // Got error response from Udacity. Terminate.
            if let error = parsedData["error"] as? String {
                completionHandler(user: nil, errorString: error)
                return
            }
            
            if let accountKey = parsedData["account"]!!["key"] as? String,
                let sessionExpiration = parsedData["session"]!!["expiration"] as? String,
                let sessionId = parsedData["session"]!!["id"] as? String {
                    let user = UdacityUser(userId: accountKey, sessionExpiration: sessionExpiration, sessionId: sessionId)
                    
                    // Got the user.
                    completionHandler(user: user, errorString: nil)
                    return
            }
            
            // Just in case of unknown scenarios
            completionHandler(user: nil, errorString: UNKNOWN_ERROR)
        }
    }
    
    static func getUdacitySessionWithFacebook(completionHandler: (user: UdacityUser?, errorString: String?) -> Void) {
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        let data = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}"
        let headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        
        Network.post(Config.UdacityUrls.getSession, headers: headers, data: data) { data, errorString in
            loginCompletionHandler(data, errorString: errorString, completionHandler: completionHandler)
        }
    }
    
    private static func loginCompletionHandler(data: AnyObject?, errorString: String?, completionHandler: (user: UdacityUser?, errorString: String?) -> Void)
    {
        if let errorMessage = errorString where errorString != nil {
            completionHandler(user: nil, errorString: errorMessage)
            return
        }
        
        /* subset response data! */
        let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
        var parsedData: AnyObject
        
        do {
            parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            completionHandler(user: nil, errorString: BAD_DATA)
            return
        }
        
        // Got error response from Udacity. Terminate.
        if let error = parsedData["error"] as? String {
            completionHandler(user: nil, errorString: error)
            return
        }
        
        if let accountKey = parsedData["account"]!!["key"] as? String,
            let sessionExpiration = parsedData["session"]!!["expiration"] as? String,
            let sessionId = parsedData["session"]!!["id"] as? String {
                let user = UdacityUser(userId: accountKey, sessionExpiration: sessionExpiration, sessionId: sessionId)
                
                // Got the user.
                completionHandler(user: user, errorString: nil)
                return
        }
        
        // Just in case of unknown scenarios
        completionHandler(user: nil, errorString: UNKNOWN_ERROR)
    }
}