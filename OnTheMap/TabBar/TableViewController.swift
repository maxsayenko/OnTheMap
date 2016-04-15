//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/7/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    override func viewDidLoad() {

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedModel.sharedInstance.students!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")! as UITableViewCell
        
        // TODO: error checks
        let model = SharedModel.sharedInstance.students![indexPath.row]
        
        cell.textLabel?.text = "\(model.firstName) \(model.lastName)"
        cell.detailTextLabel?.text = model.mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let didOpen = UIApplication.sharedApplication().openURL(NSURL(string:(cell.detailTextLabel?.text)!)!)
            if(!didOpen) {
                print("Put Error Message here. Didn't open.")
            }
        }
    }
}
