//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/29/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        setUIState(isEnabled: false)
        UdacityNetworkHelper.getStudentsData { (students, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                print("ERROR - MapViewController \(errorMessage)")
                return
            }

            SharedModel.sharedInstance.students = students
            
            performUIUpdatesOnMain({ () -> Void in
                self.setUIState(isEnabled: true)
            })
        }
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
        spinner.hidden = isEnabled
        mapView.zoomEnabled = isEnabled
        mapView.scrollEnabled = isEnabled
        mapView.userInteractionEnabled = isEnabled
        
        if(isEnabled) {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
}
