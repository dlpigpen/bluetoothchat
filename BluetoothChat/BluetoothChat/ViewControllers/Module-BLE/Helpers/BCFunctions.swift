//
//  BCFunctions.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/2/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import Foundation

// Delay a function in seconds using GCD
// Usage: delay(0.5) { foo() }
// http://stackoverflow.com/a/24318861/4504948

public func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}