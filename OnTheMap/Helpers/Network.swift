//
//  Network.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/30/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation

struct Network {
    static func get(url: String, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        get(url, headers: nil, completionHandler: completionHandler)
    }
    
    static func get(url: String, headers: [String : String]?, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        request(url, headers: headers, method: "GET", data: nil, completionHandler: completionHandler)
    }
    
    static func post(url: String, data: String, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        post(url, headers: nil, data: data, completionHandler: completionHandler)
    }
    
    static func post(url: String, headers: [String : String]?, data: String, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        request(url, headers: headers, method: "POST", data: data, completionHandler: completionHandler)
    }
    
    static func put(url: String, headers: [String : String]?, data: String, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        request(url, headers: headers, method: "PUT", data: data, completionHandler: completionHandler)
    }
    
    static func delete(url: String, headers: [String : String]?, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        request(url, headers: headers, method: "DELETE", data: nil, completionHandler: completionHandler)
    }
    
    static func request(url: String, headers: [String : String]?, method: String, data: String?, completionHandler: (data: AnyObject?, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        
        if let headers = headers {
            headers.forEach { (key, value) -> () in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let data = data {
            request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Got an Error. Terminate.
            guard (error == nil) else {
                completionHandler(data: nil, errorString: error?.localizedDescription)
                return
            }
            
            // Was there any data returned? */
            guard let data = data else {
                completionHandler(data: nil, errorString: "No data was returned by the request!")
                return
            }
            
            completionHandler(data: data, errorString: nil)
        }
        
        task.resume()
    }
}