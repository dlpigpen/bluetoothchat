//
//  RoomObject.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit

class RoomObject: NSObject {
    var rowID:NSInteger! = 0
    var nameAnother:String! = ""
    var uIIDAnother:String! = ""
}


class RoomModel: NSObject {
    
    // Create a new room
    func createARoom(nameAnother:String,uIIDAnother:String) {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if db.executeUpdate("INSERT INTO Room VALUES (?,?)", withArgumentsInArray: [nameAnother,uIIDAnother]) {
                
            }
        }
    }
    
    // Delete a room roomID
    func deleteARoom(roomID: NSString)
    {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            db.executeUpdate("DELETE FROM Room WHERE UIIDAnother = ?", withArgumentsInArray: [roomID])
        }
    }
    
    // Delete all room
    func deleteAllRoom() {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if let _: FMResultSet = db.executeQuery("DELETE FROM Room", withArgumentsInArray: nil) {
                
            }
        }
    }
    
    // Get all room
    func getAllRoom()-> NSMutableArray {
        let results = NSMutableArray()
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if let appointmentResults:FMResultSet = db.executeQuery("SELECT rowid,* FROM Room ORDER BY rowid DESC", withParameterDictionary: nil) {
            while appointmentResults.next(){
                let dict = appointmentResults.resultDictionary()
                let roomObject:RoomObject! = RoomObject()
                roomObject.nameAnother = dict["NameAnother"] as! String
                roomObject.uIIDAnother = dict["UIIDAnother"] as! String
                roomObject.rowID = dict["rowid"] as! Int
                
                results.addObject(roomObject)
            }
        }
        }
        return results
    }
    
    // Get a room by room ID: uIIDAnother
    func getRoomByID(uIIDAnother: String) -> NSMutableArray {
        let results = NSMutableArray()
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if let appointmentResults: FMResultSet = db.executeQuery("SELECT rowid,* FROM Room WHERE UIIDAnother = ?", withArgumentsInArray:  [uIIDAnother]) {
                while appointmentResults.next(){
                    let dict = appointmentResults.resultDictionary()
                    let roomObject:RoomObject! = RoomObject()
                    roomObject.nameAnother = dict["NameAnother"] as! String
                    roomObject.uIIDAnother = dict["UIIDAnother"] as! String
                    roomObject.rowID = dict["rowid"] as! Int
                    
                    results.addObject(dict)
                }
            }
        }
        return results
    }
}
