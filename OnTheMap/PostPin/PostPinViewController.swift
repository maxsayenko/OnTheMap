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
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBAction func finClicked(sender: UIButton) {
        if(locationTextField.text!.isEmpty) {
            UIHelper.showErrorMessage(self, message: "Must Enter a Location")
            return
        }
        
        let address = locationTextField.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) { (placemarks, error) -> Void in
            
            if(error != nil) {
                UIHelper.showErrorMessage(self, message: "Could Not Geocode the String.")
                return
            }
            
            let pinMapScreen = (self.storyboard?.instantiateViewControllerWithIdentifier("pinMapViewController"))! as! PinMapViewController
            pinMapScreen.userName = self.userName
            pinMapScreen.locationString = self.locationTextField.text
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
        
        locationTextField.backgroundColor = UIColor.clearColor()
        let placeholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        locationTextField.attributedPlaceholder = placeholder
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
