//
//  PostPinViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/15/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class PostPinViewController: UIViewController, UITextFieldDelegate {
    
    var name: String = ""
    
    @IBAction func cancelClicked(sender: UIButton) {
        print(self.presentingViewController)
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBOutlet var locationText: UITextView!
    
    @IBAction func finClicked(sender: UIButton) {
        if(locationText.text.isEmpty) {
            UIHelper.showErrorMessage(self, message: "Must Enter a Location")
            return
        }
        
        let address = locationText.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
            
            if(error != nil) {
                UIHelper.showErrorMessage(self, message: "Could Not Geocode the String.")
                return
            }
            
            let pinMapScreen = (self.storyboard?.instantiateViewControllerWithIdentifier("pinMapViewController"))! as! PinMapViewController
            pinMapScreen.firstName = "afas"
            pinMapScreen.lastName = "gggg"
            
            if let placemark = placemarks?.first {
                pinMapScreen.placemark = placemark
            }
            
            self.presentViewController(pinMapScreen, animated: false, completion: nil)
        }
    }
    
    // Dismissing keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
