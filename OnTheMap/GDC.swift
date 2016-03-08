//
//  GDC.swift
//  OnTheMap
//
//  Created by Max Saienko on 3/5/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}