//
//  UIHelper.swift
//  OnTheMap
//
//  Created by Max Saienko on 4/15/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation
import UIKit

struct UIHelper {
    static func showErrorMessage(controller: UIViewController, message: String) -> Void
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        controller.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func showOverwriteMessage(controller: UIViewController, message: String, handler: ((UIAlertAction) -> Void)?) -> Void {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: handler))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        controller.presentViewController(alertController, animated: true, completion: nil)
    }
}