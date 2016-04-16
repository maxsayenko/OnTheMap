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
    var name: String = ""
    var placemark: CLPlacemark? = nil

    @IBOutlet var mapView: MKMapView!
    
    @IBAction func cancelClicked(sender: AnyObject) {
        presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        print(name)
        print(placemark)
        mapView.addAnnotation(MKPlacemark(placemark: placemark!))
        //mapView.showAnnotations(mapView.annotations, animated: true)
        
        
        // get the particular pin that was tapped
        let pinToZoomOn = mapView.annotations[0]
        
        // optionally you can set your own boundaries of the zoom
        let span = MKCoordinateSpanMake(2, 2)
        
        // or use the current map zoom and just center the map
        // let span = mapView.region.span
        
        // now move the map
        let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
//    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        print(mapView.region)
//    }
}
