//
//  ViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 2/24/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBAction func loginPressed(sender: UIButton) {
//        setUIState(isEnabled: false)
//        getSession()
//        let loginManager = FBSDKLoginManager()
//        loginManager.logOut()
        getSession(isFacebook: true)
    }
    
    override func viewDidLoad() {
        self.setUIState(isEnabled: true)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("already logged in")
            print(FBSDKAccessToken.currentAccessToken().tokenString)
            print(FBSDKAccessToken.currentAccessToken().appID)
            // User is already logged in, do work such as go to next view controller.
            getSession(isFacebook: true)
        }
        else {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email"]
            loginView.delegate = self
        }
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        print(FBSDKAccessToken.currentAccessToken().tokenString)
        
        if ((error) != nil)
        {
            print("ERROR")
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("Canceled")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                print("Good")
                print(result)
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    
    
    func getSession(isFacebook isFacebook: Bool) {
        let email = emailText.text!
        let password = passwordText.text!
        
        if(isFacebook) {
            UdacityNetworkHelper.getUdacitySessionWithFacebook({ (user, errorString) -> Void in
                self.handleLogin(user, errorString: errorString)
            })
        } else {
            UdacityNetworkHelper.getUdacitySession(email, password: password) { user, errorString in
                self.handleLogin(user, errorString: errorString)
            }
        }
    }
    
    func handleLogin(user: UdacityUser?, errorString: String?) -> Void {
        if let errorMessage = errorString where errorString != nil {
            performUIUpdatesOnMain({ () -> Void in
                UIHelper.showErrorMessage(self, message: errorMessage)
                self.setUIState(isEnabled: true)
            })
            return
        }
        
        SharedModel.sharedInstance.user = user
        
        if let user = SharedModel.sharedInstance.user {
            UdacityNetworkHelper.getUdacityUser(user.userId) { (userInfo, errorString) -> Void in
                if let errorMessage = errorString where errorString != nil {
                    performUIUpdatesOnMain({ () -> Void in
                        UIHelper.showErrorMessage(self, message: errorMessage)
                        self.setUIState(isEnabled: true)
                    })
                    return
                }
                
                SharedModel.sharedInstance.user?.firstName = userInfo!.firstName
                SharedModel.sharedInstance.user?.lastName = userInfo!.lastName
                
                performUIUpdatesOnMain({ () -> Void in
                    self.performSegueWithIdentifier("segueToMapTableView", sender: nil)
                })
            }
        }
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
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