//
//  ChatingObject.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit


class ChattingModel: ModelManager {
    
    // Create a chat record
    func createAChatting(chattingObject:BCMessage!)
    {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if db.executeUpdate("INSERT INTO Chatting VALUES (?,?,?,?,?,?)", withArgumentsInArray: [!chattingObject.isSelf,chattingObject.message,chattingObject.timestamp, chattingObject.peripheralID!.UUIDString, chattingObject.isStatus, chattingObject.isRead])
            {
                
            }
        }
    }
    
    // Delete a chat record by roomID
    func deleteChatting(roomID: String)
    {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if db.executeUpdate("DELETE FROM Chatting WHERE RoomID = ?", withArgumentsInArray: [roomID]) {
                
            }
        }
    }
    
    // Delete all chating records without require any parameters
    func deleteAllChatting()
    {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if db.executeUpdate("DELETE FROM Chatting", withArgumentsInArray: nil) {
                
            }
        }
    }
    
    // Update records to be read
    func updateStatusReadAll(roomID:String) {
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if db.executeUpdate("UPDATE Chatting SET isRead = 1 WHERE RoomID = ?", withArgumentsInArray: [roomID]) {
                
            }
        }
    }
    
    // Get all records chat by roomID, and a parameter of who you are chatting. If the isAnother is false, the name will be set and otherwise
    func getChattingByPeripheralID(roomID: String, name: String) -> NSMutableArray {
        let results = NSMutableArray()
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if let appointmentResults:FMResultSet = db.executeQuery("SELECT rowid,* FROM Chatting WHERE RoomID = ? ORDER BY rowid DESC", withArgumentsInArray: [roomID]) {
                
                let currentID = Common().makeUUID()
                while appointmentResults.next(){
                    let dict = appointmentResults.resultDictionary()
                    
                    let isAnother = dict["IsAnother"] as! Bool
                    let comment = dict["Comment"] as! String
                    let date = dict["Date"] as! String
                    let isStatus = dict["isStatus"] as! Bool
                    
                    //--doi ten
                    var currentName =  BCDefaults.stringForKey(.Name)! + "," + currentID
                    if (isAnother) {
                        currentName =  name
                    }
                    
                    let chattingObject:BCMessage! = BCMessage(message: comment, name: currentName, isSelf: isAnother, isStatus: isStatus, timestamp: date,  isRead: false)
                    results.addObject(chattingObject)
                }
            }
        }
        return results
    }
    
    // Get chatting by room ID
    func getChattingUnreadByPeripheralID(roomID: String) -> NSMutableArray {
        let results = NSMutableArray()
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if let appointmentResults:FMResultSet = db.executeQuery("SELECT rowid,* FROM Chatting WHERE RoomID = ? AND isRead = 0 ORDER BY rowid DESC", withArgumentsInArray: [roomID]) {
                while appointmentResults.next(){
                    let dict = appointmentResults.resultDictionary()
                    
                    let isAnother = dict["IsAnother"] as! Bool
                    let comment = dict["Comment"] as! String
                    let date = dict["Date"] as! String
                    let isStatus = dict["isStatus"] as! Bool
                    
                    //--doi ten
                    let currentName =  BCDefaults.stringForKey(.Name)!
                    
                    let chattingObject:BCMessage! = BCMessage(message: comment, name: currentName, isSelf: isAnother, isStatus: isStatus, timestamp: date,  isRead: false)
                    results.addObject(chattingObject)
                }
            }
        }
        return results
    }
    
    
    // Get chatting by room ID
    func getChattingUnreadByPeripheral() -> NSMutableArray {
        let results = NSMutableArray()
        ModelManager.allocInstance().queueDB.inDatabase { (db:FMDatabase!) -> Void in
            if let appointmentResults:FMResultSet = db.executeQuery("SELECT rowid,* FROM Chatting WHERE isRead = 0 ORDER BY rowid DESC LIMIT 1", withArgumentsInArray: nil) {
                while appointmentResults.next(){
                    let dict = appointmentResults.resultDictionary()
                    
                    let isAnother = dict["IsAnother"] as! Bool
                    let comment = dict["Comment"] as! String
                    let date = dict["Date"] as! String
                    let isStatus = dict["isStatus"] as! Bool
                    
                    //--doi ten
                    let currentName =  BCDefaults.stringForKey(.Name)!
                    
                    let chattingObject:BCMessage! = BCMessage(message: comment, name: currentName, isSelf: isAnother, isStatus: isStatus, timestamp: date,  isRead: false)
                    results.addObject(chattingObject)
                }
            }
        }
        return results
    }

}
