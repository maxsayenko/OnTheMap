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
    
    var overlay : UIView?

    @IBAction func refreshClicked(sender: UIBarButtonItem) {
        getData()
    }
    
    @IBAction func pinClicked(sender: UIBarButtonItem) {
        let postPinScreen = (self.storyboard?.instantiateViewControllerWithIdentifier("postPinViewController"))! as! PostPinViewController

        var userName: (firstName: String, lastName: String)?
        if let user = SharedModel.sharedInstance.user {
            userName = (firstName: user.firstName!, lastName: user.lastName!)
        }

        let message = "User: \(userName!.firstName) \(userName!.lastName) Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.presentViewController(postPinScreen, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutClicked(sender: UIBarButtonItem) {
        setUIState(isEnabled: false)
        UdacityNetworkHelper.logoutUdacity { (isSuccessful, errorString) -> Void in
            if(isSuccessful) {
                performUIUpdatesOnMain({ () -> Void in
                    let loginScreen = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                    self.presentViewController(loginScreen, animated: true, completion: nil)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.8
        spinner.hidden = true

        getData()
    }
    
    func getData() {
        setUIState(isEnabled: false)
        UdacityNetworkHelper.getStudentsData { (students, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                UIHelper.showErrorMessage(self, message: errorMessage)
                return
            }
            SharedModel.sharedInstance.students = students
            
            performUIUpdatesOnMain({ () -> Void in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.setUIState(isEnabled: true)
                for info in SharedModel.sharedInstance.students! {
                    self.addPin(studentInformation: info)
                }
            })
        }
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
        for barItem in (tabBarController?.tabBar.items!)! {
            barItem.enabled = isEnabled
        }
        
        spinner.hidden = isEnabled
        mapView.zoomEnabled = isEnabled
        mapView.scrollEnabled = isEnabled
        mapView.userInteractionEnabled = isEnabled
        
        if(isEnabled) {
            spinner.stopAnimating()
            overlay?.removeFromSuperview()
        } else {
            spinner.startAnimating()
            view.addSubview(overlay!)
        }
    }
    
    func addPin(studentInformation info: StudentInformation) {
        guard let lat = info.latitude,
              let long = info.longitude
        else {
            print("Error during dropping pin. Info = \(info)")
            return;
        }
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "\(info.firstName) \(info.lastName)"
        objectAnnotation.subtitle = info.mediaURL
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
        guard let annotation = view.annotation where annotation.subtitle != nil else {
            return
        }
        
        guard let urlString = annotation.subtitle! else {
            return
        }
        
        if (control == view.rightCalloutAccessoryView) {
            let didOpen = UIApplication.sharedApplication().openURL(NSURL(string:urlString)!)
            if(!didOpen) {
                UIHelper.showErrorMessage(self, message: "Bad URL address")
            }
        }
    }
}
