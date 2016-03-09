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
        UdacityNetworkHelper.getUdacitySession(email, password: password) { data, errorString in
            if let errorMessage = errorString where errorString != nil {
                // TODO: SHow alert view contrlr
                print(errorMessage)
                return
            }
            
            if let accountKey = data!["account"]!!["key"] as? String,
                let sessionExpiration = data!["session"]!!["expiration"] as? String,
                let sessionId = data!["session"]!!["id"] as? String {
                    let user = UdacityUser(accountKey: accountKey, sessionExpiration: sessionExpiration, sessionId: sessionId)
                    print(user)
                    
                    performUIUpdatesOnMain({ () -> Void in
                        self.performSegueWithIdentifier("segueToMapTableView", sender: nil)
                    })
            }
        }
    }
}