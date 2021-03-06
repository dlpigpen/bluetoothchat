//
//  UIApplication+Extensions.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/2/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit

// MARK: - Singletons

extension UIApplication {

    class var APP_VERSION: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }

    class var APP_BUILD: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    }
}

// MARK: - Helper Methods

extension UIApplication {

    class func applicationState() -> String {
        switch sharedApplication().applicationState {
            case .Active:
                return "Active"
            case .Inactive:
                return "Inactive"
            case .Background:
                return "Background"
        }
    }

    // Present an alert from anywhere
    class func presentAlert(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))

        if let window = sharedApplication().keyWindow,
               rootViewController = window.rootViewController {
            rootViewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
}