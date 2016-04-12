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
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBAction func loginPressed(sender: UIButton) {
        setUIState(false)
        getSession(emailText.text!, password: passwordText.text!)
    }
    
    override func viewDidLoad() {
        self.setUIState(true)
    }
    
    //TODO: Block UI and show spinner while loading
    func getSession(email: String, password: String) {
        UdacityNetworkHelper.getUdacitySession(email, password: password) { user, errorString in
            if let errorMessage = errorString where errorString != nil {
                performUIUpdatesOnMain({ () -> Void in
                    let alertController = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.setUIState(true)
                })
                return
            }
            
            SharedModel.sharedInstance.user = user
            
            performUIUpdatesOnMain({ () -> Void in
                self.performSegueWithIdentifier("segueToMapTableView", sender: nil)
            })
        }
    }
    
    func setUIState(isEnabled: Bool) {
        spinner.hidden = isEnabled
        emailText.enabled = isEnabled
        passwordText.enabled = isEnabled
        loginBtn.enabled = isEnabled
        
        if(isEnabled) {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }

    }
}