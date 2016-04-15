//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/7/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var overlay: UIView?
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    @IBAction func refreshCliked(sender: UIBarButtonItem) {
        getData()
    }
    
    @IBAction func pinClicked(sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutClicked(sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.8
        overlay?.hidden = true
        
        spinner.center = view.center
        //spinner.frame = CGRect(origin: overlay!.center, size: CGSize(width: 50, height: 50))
        spinner.frame = CGRect(x: UIScreen.mainScreen().bounds.width/2 - 25, y: UIScreen.mainScreen().bounds.height/2 - 50, width: 50, height: 50)
        overlay?.addSubview(spinner)
        view.addSubview(overlay!)
    }
    
    func getData() {
        setUIState(isEnabled: false)
        UdacityNetworkHelper.getStudentsData { (students, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                print("ERROR - TableViewController \(errorMessage)")
                return
            }
            SharedModel.sharedInstance.students = students
            
            performUIUpdatesOnMain({ () -> Void in
                self.setUIState(isEnabled: true)
                self.tableView.reloadData()
            })
        }
    }
    
    func setUIState(isEnabled isEnabled: Bool) {
        for barItem in (tabBarController?.tabBar.items!)! {
            barItem.enabled = isEnabled
        }
        
        //spinner.hidden = isEnabled
        overlay?.hidden = isEnabled
        
        if(isEnabled) {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
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
