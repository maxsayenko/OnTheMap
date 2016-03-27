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
        UdacityNetworkHelper.getUdacitySession(email, password: password) { user, errorString in
            if let errorMessage = errorString where errorString != nil {
                // TODO: SHow alert view contrlr
                print("Login VC - \(errorMessage)")
                performUIUpdatesOnMain({ () -> Void in
                    let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            performUIUpdatesOnMain({ () -> Void in
                self.performSegueWithIdentifier("segueToMapTableView", sender: nil)
            })
            
        }
    }
}