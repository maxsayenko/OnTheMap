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
    var overlay: UIView?
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    @IBAction func loginPressed(sender: UIButton) {
        getSession(isFacebook: false)
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
        overlay?.hidden = isEnabled
    }
    
    override func viewDidLoad() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
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
        
        overlay = UIHelper.getLoadingState(view).overlay
        self.setUIState(isEnabled: true)
    }
    
    func getSession(isFacebook isFacebook: Bool) {
        setUIState(isEnabled: false)
        SharedModel.sharedInstance.isFacebook = isFacebook
        
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
    
    private func handleLogin(user: UdacityUser?, errorString: String?) -> Void {
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
}


    // Facebook Delegate Methods
extension LoginViewController {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            UIHelper.showErrorMessage(self, message: error.localizedDescription)
        }
        else if result.isCancelled {
            // Handle cancellations
            UIHelper.showErrorMessage(self, message: "You have cancelled Facebook login")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                getSession(isFacebook: true)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
}