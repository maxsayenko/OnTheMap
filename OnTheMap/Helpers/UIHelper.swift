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
    
    static func getLoadingState(view: UIView) -> (overlay: UIView, spinner: UIActivityIndicatorView) {
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        let overlay = UIView(frame: view.frame)
        
        overlay.backgroundColor = UIColor.blackColor()
        overlay.alpha = 0.8
        overlay.hidden = true
        
        spinner.frame = CGRect(x: UIScreen.mainScreen().bounds.width/2 - 25, y: UIScreen.mainScreen().bounds.height/2 - 50, width: 50, height: 50)
        overlay.addSubview(spinner)
        view.addSubview(overlay)
        
        return (overlay: overlay, spinner: spinner)
    }
}