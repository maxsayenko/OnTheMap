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
                self.addPin()
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
    
    func addPin() {
        print(__FUNCTION__)
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.773972, -122.431297)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "boooo"
        objectAnnotation.subtitle = "http://google.com"
        mapView.addAnnotation(objectAnnotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    // Called when the annotation was added
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if (pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.draggable = true
            pinView?.pinTintColor = UIColor.purpleColor()
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // Tapping the annotation bubble
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(__FUNCTION__)
        print(control)
        if (control == view.rightCalloutAccessoryView) {
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.apple.com")!)
        }
    }
}
