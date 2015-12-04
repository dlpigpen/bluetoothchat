//
//  BCChatViewController.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit
import CoreBluetooth
import CocoaLumberjack
import SlackTextViewController
import AudioToolbox

// MARK: - Properties

final class BCChatViewController: SLKTextViewController {

    var idRoom: String!
    var nameToUser: String!
    var cachedMessages: NSMutableArray = NSMutableArray()
    var cachedHeights: [Int: CGFloat] = [:]

    // MARK: Initializers

    init() {
        super.init(tableViewStyle: .Plain)
    }

    required convenience init!(coder decoder: NSCoder!) {
        self.init()
    }
}

// MARK: - View Lifecycle

extension BCChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "Chat with \(nameToUser)"
        
        registerNotification()
        configureViewController()
        setupViewController()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        
        // Make sure keyboard is not showing when we rewind back
        view.endEditing(true)

        super.viewWillDisappear(animated)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        // Reset cachedHeights on orientation change
        cachedHeights = [:]
    }

    // MARK: Setup Methods

    private func configureViewController() {

        // Configure text input
        shakeToClearEnabled = true

        //--create new room
        let roomModel = RoomModel()
        if roomModel.getRoomByID(idRoom).count  == 0 {
                roomModel.createARoom(nameToUser, uIIDAnother: idRoom)
        }
        
        // Retrieve cached messages from local database
        let chatModel = ChattingModel()
        let listMessages = chatModel.getChattingByPeripheralID(idRoom, name: nameToUser)
        if listMessages.count > 0 {
            cachedMessages = listMessages
        } else {
            cachedMessages = NSMutableArray()
        }

        // Register custom table view cell class for reuse
        tableView.registerClass(BCChatTableViewCell.self, forCellReuseIdentifier: CHAT_CELL_IDENTIFIER)
    }

    private func setupViewController() {
        
        title = "Chatroom"

        // Setup table view
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight

        // Change text view placeholder
        textView.placeholder = "Type a message…"

        setupName()
    }

    private func setupName() {

    }
}


// MARK: - User Interaction

extension BCChatViewController {

    override func didPressRightButton(sender: AnyObject!) {

        // Finish any auto-correction
        textView.refreshFirstResponder()
        
        // sen message
        Common.getAppDelegate().peripheralManager.sendMessage(self.textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), roomID:  idRoom)
        
        textView.text = ""

        super.didPressRightButton(sender)
    }
}

// MARK: - Delegates

// MARK: BCChatRoomProtocol

extension BCChatViewController: BCChatRoomProtocol {

    func didStartScanning() {

    }

    func didFinishScanning() {
        
        // Add the scan button back
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "scanButtonTapped:")
    }

    func updateWithNewMessage(message: BCMessage, isStatus: Bool? = false) {

        // Cache new message locally
        cachedMessages.insertObject(message, atIndex: 0)

        // Update the table view with the new message
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        tableView.endUpdates()

        // Vibrate phone when receiving new message
        if !message.isSelf {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }

        // Scroll to most recent message if user sent it
        if message.isSelf {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    func userJoined(name: String, peripheralID: NSUUID) {
    }

    func userLeft(peripheralID: NSUUID) {
    }
    
    func removeAllUser() {
        
    }
}

// MARK: UITableViewDelegate

extension BCChatViewController {

    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return action == "copy:"
    }

    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action == "copy:" {
            let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! BCChatTableViewCell
            UIPasteboard.generalPasteboard().string = cell.chatMessage
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < cachedMessages.count {
            let message = cachedMessages[indexPath.row]

            // Return cached height if it's been stored
            if cachedHeights[message.hashValue] != nil {
                return cachedHeights[message.hashValue]!
            } else {

                // Set the message and meta data for the cell
                let cell = BCChatTableViewCell(style: .Default, reuseIdentifier: CHAT_CELL_IDENTIFIER)
                cell.message = message as! BCMessage
                cell.showMetaData = true

                // Relayout the cell's subviews
                cell.layoutIfNeeded()

                // Resizes labels for rotation
                cell.layoutMessageLabelWithNewContainerWidth(tableView.bounds.width)

                // Cache the height of the cell to reduce future calculations
                cachedHeights[message.hashValue] = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
                return cachedHeights[message.hashValue]!
            }
        }
        return tableView.rowHeight
    }
}

// MARK: UITableViewDataSource

extension BCChatViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cachedMessages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Initialize or dequeue a cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CHAT_CELL_IDENTIFIER, forIndexPath: indexPath) as! BCChatTableViewCell
        cell.transform = tableView.transform
        cell.selectionStyle = .None

        // Set the message and meta data for the cell
        if indexPath.row < cachedMessages.count {
            let bcMessage = cachedMessages[indexPath.row] as! BCMessage
            cell.message = bcMessage
            cell.showMetaData = true
        }
        return cell
    }
}

// MARK: UIGestureRecognizerDelegate

extension BCChatViewController {

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {

        // Don't hide keyboard on tapping table view
        if textView.isFirstResponder() && gestureRecognizer == singleTapGesture {
            return false
        }
        return true
    }
}

extension BCChatViewController {
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadChatBox"), name: AppDelegateMessage.KeyNotifications.ReloadChatbox.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userLeftFromUser"), name: AppDelegateMessage.KeyNotifications.UserLeft.rawValue, object: nil)
    }
    
    func reloadChatBox() {
        
        // Retrieve cached messages from local database
        let chatModel = ChattingModel()

        //-- pass name other chatter to show in the list chat
        let listMessages = chatModel.getChattingByPeripheralID(idRoom, name: nameToUser)
        if listMessages.count > 0 {
            cachedMessages = listMessages
        } else {
            cachedMessages = NSMutableArray()
        }

        
        // Vibrate phone when receiving new message
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    
        //--update database to readl all
        chatModel.updateStatusReadAll(idRoom)
        
        // reload data
        self.tableView.reloadData()

    }
    
    //--delete all list chat and go back
    func userLeftFromUser() {
        
        reloadChatBox()
        
    }
}

// MARK: - Helper Methods

extension BCChatViewController {

    // Helper function to determine if current messsage should show meta data or not
    // Returns true if previous message is either a different user or older than 5 minutes
//    func isDifferentThanPreviousMessage(messages: [BCMessage], indexPath: NSIndexPath) -> Bool {
//        if indexPath.row == messages.count - 1 {
//            return true
//
//        } else if indexPath.row < messages.count - 1 {
//            let currentMessage = messages[indexPath.row]
//            let previousMessage = messages[indexPath.row + 1]
//            if currentMessage.isDifferentUserThan(previousMessage) || currentMessage.isSignificantlyOlderThan(previousMessage) {
//                return true
//            }
//        }
//        return false
//    }
}