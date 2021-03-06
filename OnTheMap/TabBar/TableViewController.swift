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
    
    @IBAction func refreshCliked(sender: UIBarButtonItem) {
        getData()
    }
    
    @IBAction func pinClicked(sender: UIBarButtonItem) {
        UIHelper.launchPostPinModal(self)
    }
    
    @IBAction func logoutClicked(sender: UIBarButtonItem) {
        setUIState(isEnabled: false)
        UdacityNetworkHelper.logoutUdacity { (isSuccessful, errorString) -> Void in
            if(isSuccessful) {
                performUIUpdatesOnMain({ () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        overlay = UIHelper.getLoadingState(view).overlay
    }
    
    func getData() {
        setUIState(isEnabled: false)
        UdacityNetworkHelper.getStudentsData { (students, errorString) -> Void in
            if let errorMessage = errorString where errorString != nil {
                UIHelper.showErrorMessage(self, message: errorMessage)
                performUIUpdatesOnMain({ () -> Void in
                    self.setUIState(isEnabled: true)
                })
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
        overlay?.hidden = isEnabled
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedModel.sharedInstance.students!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")! as UITableViewCell
        
        let model = SharedModel.sharedInstance.students![indexPath.row]
        
        cell.textLabel?.text = "\(model.firstName) \(model.lastName)"
        cell.detailTextLabel?.text = model.mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            // Oddly can't use !cell.detailTextLabel?.text?.isEmpty here
            guard let urlString = cell.detailTextLabel?.text where (cell.detailTextLabel?.text != nil) && (cell.detailTextLabel?.text!.isEmpty == false) else {
                UIHelper.showErrorMessage(self, message: "Bad URL address")
                return
            }

            if let url = NSURL(string:urlString) {
                let didOpen = UIApplication.sharedApplication().openURL(url)
                if(!didOpen) {
                    UIHelper.showErrorMessage(self, message: "Bad URL address")
                }
            } else {
                UIHelper.showErrorMessage(self, message: "Bad URL address")
                return
            }
        }
    }
}

extension TableViewController: PostPinModalDelegate {
    func refreshData() {
        getData()
    }
}
