//
//  UdacityNetworkHelper.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/9/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//
import Foundation

struct UdacityNetworkHelper {
    static let EMPTY_EMAIL_PASSWORD = "Email and password are required"
    static let BAD_DATA = "Error in reading response"
    static let UNKNOWN_ERROR = "Something went wrong"
    
    static func getUdacitySession(email: String, password: String, completionHandler: (user: UdacityUser?, errorString: String?) -> Void) {
        guard (!email.isEmpty && !password.isEmpty) else {
            completionHandler(user: nil, errorString: EMPTY_EMAIL_PASSWORD)
            return
        }
        
        // TODO: Move Url to Config class
        let data = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        Network.post("https://www.udacity.com/api/session", headers: headers, data: data) { data, errorString in
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
                    let user = UdacityUser(accountKey: accountKey, sessionExpiration: sessionExpiration, sessionId: sessionId)
                    
                    // Got the user.
                    completionHandler(user: user, errorString: nil)
                    return
            }
            
            // Just in case of unknown scenarios
            completionHandler(user: nil, errorString: UNKNOWN_ERROR)
        }

    }
    
    static func getStudentsData() {
        let headers = [
            "X-Parse-Application-Id" : "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key" : "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        Network.get("https://api.parse.com/1/classes/StudentLocation?limit=100", headers: headers) { (data, errorString) -> Void in
            if let newData = data as! NSData? {
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                
                var parsedDictionary: NSDictionary
                
                do {
                    parsedDictionary = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                } catch {
                    print("Error in parsing JSON \(error)")
                    return
                }
                
                print("===================")
                print(parsedDictionary)
            }
        }
    }
}