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
        networkPostRequest("https://www.udacity.com/api/session", data: data) { data, errorString in
            
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
    
    private static func networkPostRequest(url: String, data: String, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Got an Error. Terminate.
            if (error != nil) {
                completionHandler(data: nil, errorString: error?.localizedDescription)
                return
            }
            
            completionHandler(data: data, errorString: nil)
        }
        
        task.resume()
    }
}
