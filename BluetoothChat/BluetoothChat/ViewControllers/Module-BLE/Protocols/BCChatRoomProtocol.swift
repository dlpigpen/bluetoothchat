//
//  BCChatRoomProtocol.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/3/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import Foundation

protocol BCChatRoomProtocol: class {

    // Notifies the chatroom about scanning
    func didStartScanning()
    func didFinishScanning()

    // Notifies the chatroom with a new message
    func updateWithNewMessage(message: BCMessage, isStatus: Bool?)

    // Notifies the chatroom with user activity
    func userJoined(name: String, peripheralID: NSUUID)
    func userLeft(peripheralID: NSUUID)
    func removeAllUser()
}