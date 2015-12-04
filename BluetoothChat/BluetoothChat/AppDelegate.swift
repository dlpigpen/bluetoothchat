//
//  AppDelegate.swift
//  BluetoothChat
//
//  Created by Duc Nguyen Van on 11/18/15.
//  Copyright © 2015 Duc Nguyen Van. All rights reserved.
//

import UIKit
import CocoaLumberjack
import SwiftColors
import AudioToolbox


// structure notification of system message
struct AppDelegateMessage {
    
    enum KeyNotifications: String {
        case UpdateList       = "com.bluetooth.UpdateList"
        case StartScanning    = "com.bluetooth.StartScanning"
        case FinishScanning   = "com.bluetooth.FinishScanning"
        case ReloadChatbox    = "com.bluetooth.ReloadChatBox"
        case UserLeft         = "com.bluetooth.UserLeft"
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BCChatRoomProtocol {

    var window: UIWindow?
    var centralManager = BCCentralManager()
    var peripheralManager = BCPeripheralManager()
    
    // consider
    var cachedMessages: [BCMessage]!
    var cachedHeights: [Int: CGFloat] = [:]
    var chatroomUsers: [NSUUID: String] = [:]
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        Common.getAppDelegate().setupApplication()
        Common.getAppDelegate().configureApplication()
        
        //  Generate tmp folder in cache
        Common.initDirectory()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        // set badgle to zero
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
 
        NSNotificationCenter.defaultCenter().postNotificationName("didRegisterUserNotificationSettings", object: nil)
    }

}

// MARK: - Delegates

// MARK: BCChatRoomProtocol
extension AppDelegate {
    
    func scanPeripheral() {
        // Start looking for connections for 10 seconds
        centralManager.startScanning(10)
        peripheralManager.startAdvertising(10)
    }
    
    func stopPeripheral() {
        // Stop scanning if view controller disappears
        centralManager.stopScanning()
        peripheralManager.stopAdvertising()
        

    }
    
    func didStartScanning() {
        notifyStartScanning()
    }
    
    func didFinishScanning() {
        notifyFinishScanning()
    }
    
    func updateWithNewMessage(message: BCMessage, isStatus: Bool? = false) {
        
        //--check room if there is no in the database, we create new. message receive
        let roomModel = RoomModel()
        let idRoom = message.peripheralID!.UUIDString
        if isStatus == false {
            if roomModel.getRoomByID(idRoom).count  == 0 {
                if let udid = message.udidreceive {
                    if udid == Common().makeUUID() { //--only create if the device receive is the same
                        roomModel.createARoom(message.name + "," + idRoom, uIIDAnother: idRoom)
                    }
                }
            }
        }
        
        //--notifiy to there has new message from system
        fireNotification(message.name, body: message.message)
        notifyReloadData()
    
    }
    
    func userJoined(name: String, peripheralID: NSUUID) {
        if let oldName = chatroomUsers[peripheralID] {
            if oldName != name {
                
                // Update user's name in local cache
                chatroomUsers[peripheralID] = name
                
                let timestamp = NSDate().toString()
                let metaDataName =  name.componentsSeparatedByString(",")
                let udid = metaDataName.last!
                let nameFilter = metaDataName.first!
                let message = BCMessage(message: "> Changed their name to \(nameFilter)", name: oldName, isSelf: false, isStatus: true, timestamp: timestamp, isRead: false, peripheralID: NSUUID(UUIDString: udid))
                
                //store database
                let chatModel = ChattingModel()
                chatModel.createAChatting(message)
                
                // Send status message
                updateWithNewMessage(message, isStatus: true)
                
                // ring sound
                if !message.isSelf {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
        } else {
            // Add user to local cache
            chatroomUsers[peripheralID] = name
            
            // Create and add status message to local database
            let timestamp = NSDate().toString()
            let udid = name.componentsSeparatedByString(",").last!
            let message = BCMessage(message: "> Joined the room", name: name, isSelf: false, isStatus: true, timestamp: timestamp, isRead: false, peripheralID: NSUUID(UUIDString: udid))
            //store database
            let chatModel = ChattingModel()
            chatModel.createAChatting(message)
      
            
            // Send status message
            updateWithNewMessage(message, isStatus: true)
            
            
            if !message.isSelf {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
        
        // Update UI
         notifyListUserUI()
        
         DDLogInfo("\(name) Joined the list users")
    }
    
    func userLeft(peripheralID: NSUUID) {
        
        if let name = chatroomUsers[peripheralID] {
            
            // Remove user from local cache
            chatroomUsers.removeValueForKey(peripheralID)
            
            // Create and add status message to local database
            let timestamp = NSDate().toString()
            let udid = name.componentsSeparatedByString(",").last!
            let message = BCMessage(message: "> Left the room", name: name, isSelf: false, isStatus: true, timestamp: timestamp,  isRead: false, peripheralID: NSUUID(UUIDString: udid))
            
            //store database
            let chatModel = ChattingModel()
            chatModel.createAChatting(message)
            
            
            // Update UI
            notifyUserLeft()
            
            // Send status message
            updateWithNewMessage(message, isStatus: true)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            DDLogInfo("\(name) Left the list users")
        }
        
    }
    
    func removeAllUser() {
        
        chatroomUsers.removeAll()
        notifyListUserUI()
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    func notifyListUserUI() {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegateMessage.KeyNotifications.UpdateList.rawValue, object: nil)
    }
    
    func notifyStartScanning() {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegateMessage.KeyNotifications.StartScanning.rawValue, object: nil)
    }

    func notifyFinishScanning() {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegateMessage.KeyNotifications.FinishScanning.rawValue, object: nil)
    }
    
    func notifyReloadData() {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegateMessage.KeyNotifications.ReloadChatbox.rawValue, object: nil)
    }
    
    func notifyUserLeft() {
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegateMessage.KeyNotifications.UserLeft.rawValue, object: nil)
    }

    
    // Alert to chat user
    func fireNotification(name: String, body: String) {
        
        let notification = UILocalNotification()
        let dayFire: NSTimeInterval = 1
        
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = body;
        notification.alertTitle = "You got a message from \(name)"
        notification.applicationIconBadgeNumber = 1;
        
        notification.fireDate =  NSDate(timeInterval: dayFire, sinceDate: NSDate())
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}


// MARK: - Setup Methods

extension AppDelegate {
    
    internal func setupApplication() {
 
        setupRootViewController()
        configureViewController()
    }
    
    
    internal func configureViewController() {
        // Set delegates
        centralManager.delegate = self
        peripheralManager.delegate = self
    }
    
    internal func setupRootViewController() {
        if let myWindow =  window {
            let tabbarViewController: UITabBarController = myWindow.rootViewController as! UITabBarController
            tabbarViewController.selectedIndex = 0
            
        }
    }
    
    internal func setBadgeForTabbar(number: String) {
        if let myWindow =  window {
            let tabbarViewController: UITabBarController = myWindow.rootViewController as! UITabBarController
            if let tabbarItem = tabbarViewController.tabBar.items?.first {
                tabbarItem.badgeValue = "1"
            }
        }
    }
}

// MARK: - Configuration Methods

extension AppDelegate {
    
    internal func configureApplication() {
        configureLogger()
        logAppInformation()
    }
    
    internal func configureLogger() {
        let sharedLogger = DDTTYLogger.sharedInstance()
        sharedLogger.logFormatter = BCLogFormatter()
        
        // Enable if you have Xcode colors installed. Custom colors work best on dark background
        // https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/XcodeColors.md
        sharedLogger.colorsEnabled = true
        sharedLogger.setForegroundColor(UIColor(hexString: "#F8271B"), backgroundColor: nil, forFlag: DDLogFlag.Error)
        sharedLogger.setForegroundColor(UIColor(hexString: "#E5ED15"), backgroundColor: nil, forFlag: DDLogFlag.Warning)
        sharedLogger.setForegroundColor(UIColor(hexString: "#2FFF17"), backgroundColor: nil, forFlag: DDLogFlag.Info)
        sharedLogger.setForegroundColor(UIColor(hexString: "#31B2BB"), backgroundColor: nil, forFlag: DDLogFlag.Debug)
        sharedLogger.setForegroundColor(UIColor(hexString: "#F2BC00"), backgroundColor: nil, forFlag: DDLogFlag.Verbose)
        DDLog.addLogger(sharedLogger)
    }
    
    private func logAppInformation() {
        DDLogDebug("BluetoothChat Version \(UIApplication.APP_VERSION) (Build \(UIApplication.APP_BUILD))")
        DDLogDebug("\(BCDevice.CURRENT_DEVICE) \(BCDevice.SIMULATOR_OR_DEVICE) (iOS \(BCDevice.CURRENT_VERSION))")
        DDLogInfo("App Successfully Launched (\(BCDevice.CONFIGURATION) Mode)")
    }
}

