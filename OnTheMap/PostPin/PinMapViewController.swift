//
//  test.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/15/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class PinMapViewController: UIViewController, MKMapViewDelegate {
    var delegate: PostPinModalDelegate? = nil
    var overlay: UIView?
    
    var userName: (firstName: String, lastName: String)?
    var placemark: CLPlacemark? = nil
    var locationString: String?
    
    var pin: MKAnnotation?

    @IBOutlet var linkTextField: UITextField!

    @IBOutlet var mapView: MKMapView!
    
    @IBAction func submitClicked(sender: UIButton) {
        setUIState(isEnabled: false)
        
        let lat = (pin?.coordinate.latitude)! as Double
        let long = (pin?.coordinate.longitude)! as Double
        let locationId: String? = SharedModel.sharedInstance.user?.postedLocationId
        
        UdacityNetworkHelper.sendStudentLocation(locationId, uniqueKey: "qwert", firstName: userName!.firstName, lastName: userName!.lastName, mapString: locationString!, mediaURL: linkTextField.text!, lat: lat, long: long) { (objectId, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                performUIUpdatesOnMain({ () -> Void in
                    self.setUIState(isEnabled: true)
                    UIHelper.showErrorMessage(self, message: errorMessage)
                })
                return
            }
            
            performUIUpdatesOnMain({ () -> Void in
                self.setUIState(isEnabled: true)
                SharedModel.sharedInstance.user?.postedLocationId = objectId
                
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.delegate?.refreshData()
                })
            });
        }
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            print(self)
        })
    }
    
    override func viewDidLoad() {
        overlay = UIHelper.getLoadingState(view).overlay
        
        linkTextField.backgroundColor = UIColor.clearColor()
        let placeholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        linkTextField.attributedPlaceholder = placeholder
        
        
        mapView.addAnnotation(MKPlacemark(placemark: placemark!))
        //mapView.showAnnotations(mapView.annotations, animated: true)
        
        pin = mapView.annotations[0]
        
        // optionally you can set your own boundaries of the zoom
        let span = MKCoordinateSpanMake(2, 2)
        
        // or use the current map zoom and just center the map
        // let span = mapView.region.span
        
        // now move the map
        let region = MKCoordinateRegion(center: pin!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
        overlay?.hidden = isEnabled
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
