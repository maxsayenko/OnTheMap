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
    var overlay: UIView?
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func refreshClicked(sender: UIBarButtonItem) {
        getData()
    }
    
    @IBAction func pinClicked(sender: UIBarButtonItem) {
        var userName: (firstName: String, lastName: String)?
        if let user = SharedModel.sharedInstance.user {
            userName = (firstName: user.firstName!, lastName: user.lastName!)
        }

        let postPinScreen = (self.storyboard?.instantiateViewControllerWithIdentifier("postPinViewController"))! as! PostPinViewController
        postPinScreen.userName = userName
        postPinScreen.delegate = self
        
        if(SharedModel.sharedInstance.user?.postedLocationId != nil) {
            let message = "User: \(userName!.firstName) \(userName!.lastName) Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
            UIHelper.showOverwriteMessage(self, message: message, handler: { (_) -> Void in
                self.presentViewController(postPinScreen, animated: true, completion: nil)
            })
        } else {
            self.presentViewController(postPinScreen, animated: true, completion: nil)
        }
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
    
    override func viewDidAppear(animated: Bool) {
        if let students = SharedModel.sharedInstance.students {
            mapView.removeAnnotations(mapView.annotations)
            addPins(students)
        }
    }
    
    override func viewDidLoad() {
        let loadingState = UIHelper.getLoadingState(view)
        overlay = loadingState.overlay
        spinner = loadingState.spinner

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
                
                self.addPins(SharedModel.sharedInstance.students!)
            })
        }
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
        for barItem in (tabBarController?.tabBar.items!)! {
            barItem.enabled = isEnabled
        }
        
        spinner!.hidden = isEnabled
        mapView.zoomEnabled = isEnabled
        mapView.scrollEnabled = isEnabled
        mapView.userInteractionEnabled = isEnabled
        
        overlay?.hidden = isEnabled
        
        if(isEnabled) {
            spinner!.stopAnimating()
        } else {
            spinner!.startAnimating()
        }
    }
    
    func addPins(infos: [StudentInformation]) {
        let annotations = infos.map { (info) -> MKPointAnnotation in
            
            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(info.latitude!, info.longitude!)
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "\(info.firstName) \(info.lastName)"
            objectAnnotation.subtitle = info.mediaURL

            return objectAnnotation
        }

        mapView.addAnnotations(annotations)
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

extension MapViewController: PostPinModalDelegate {
    func refreshData() {
        print("refreshing")
        getData()
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
            pinView?.animatesDrop = false
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
