//
//  PostPinViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/15/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class PostPinViewController: UIViewController {
    
    var name: String = ""

    @IBAction func cancelClicked(sender: UIButton) {
        print(self.presentingViewController)
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func finClicked(sender: UIButton) {
        let pinMapScreen = (self.storyboard?.instantiateViewControllerWithIdentifier("pinMapViewController"))! as! PinMapViewController
        pinMapScreen.name = "afas"
        self.presentViewController(pinMapScreen, animated: false, completion: nil)

    }
}
