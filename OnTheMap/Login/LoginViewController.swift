//
//  ViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 2/24/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var passwordText: UITextField!
    
    @IBAction func loginPressed(sender: UIButton) {
        getSession(emailText.text!, password: passwordText.text!)
    }
    
    func getSession(email: String, password: String) {
        guard (!email.isEmpty && !password.isEmpty) else {
            print("Error")
            return
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            /* subset response data! */
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            var parsedData: AnyObject
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Error in parsing JSON \(error)")
                return
            }
            
            if let accountKey = parsedData["account"]!!["key"] as? String,
                let sessionExpiration = parsedData["session"]!!["expiration"] as? String,
                let sessionId = parsedData["session"]!!["id"] as? String {
                    let t = UdacityUser(accountKey: accountKey, sessionExpiration: sessionExpiration, sessionId: sessionId)
                    print(t)
            }
            
            print(parsedData)
            
            performUIUpdatesOnMain({ () -> Void in
                self.performSegueWithIdentifier("segueToMapTableView", sender: nil)
            })
        }
        
        task.resume()
    }
}