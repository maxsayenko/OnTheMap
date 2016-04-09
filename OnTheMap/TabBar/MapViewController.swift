//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/29/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    override func viewDidLoad() {
        UdacityNetworkHelper.getStudentsData { (students, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                print("ERROR - MapViewController \(errorMessage)")
                return
            }
            
            SharedModel.sharedInstance.students = students
            print(SharedModel.sharedInstance)
        }
    }
}
