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
    var delegate: PostPinModalDelegate? = nil
    var userName: (firstName: String, lastName: String)?
    
    @IBAction func cancelClicked(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBOutlet var label: UILabel!
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
            pinMapScreen.userName = self.userName
            pinMapScreen.locationString = self.locationText.text
            pinMapScreen.delegate = self.delegate
            
            if let placemark = placemarks?.first {
                pinMapScreen.placemark = placemark
            }
            
            self.presentViewController(pinMapScreen, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        let boldWord = "studying"
        let text : NSString = label.text! as NSString

        let boldWordRange = text.rangeOfString(boldWord) as NSRange
        
        let attributedString = NSMutableAttributedString(string: label.text!, attributes: nil)
        
        attributedString.setAttributes([ NSFontAttributeName : UIFont.boldSystemFontOfSize(22)], range: boldWordRange)
        
        label.attributedText = attributedString
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
