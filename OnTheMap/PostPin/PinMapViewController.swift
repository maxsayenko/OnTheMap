//
//  test.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/15/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class PinMapViewController: UIViewController {
    var name: String = ""
    var placemark: CLPlacemark? = nil

    @IBAction func cancelClicked(sender: AnyObject) {
        presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        print(name)
        print(placemark)
    }
}
