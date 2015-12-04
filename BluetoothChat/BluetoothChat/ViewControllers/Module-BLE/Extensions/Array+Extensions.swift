//
//  Array+Extensions.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/2/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    // Credit: http://iphonedev.tv/blog/2015/9/22/how-to-remove-an-array-of-objects-from-a-swift-2-array-removeobjectsinarray

    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }

    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}