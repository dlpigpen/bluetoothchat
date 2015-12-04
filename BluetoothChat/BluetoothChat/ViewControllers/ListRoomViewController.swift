//
//  ListRoomViewController.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit
import CocoaLumberjack
import SwiftColors


class ListRoomViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableData: UITableView!
    var listRoom:NSMutableArray! = NSMutableArray()
    var footerView :UILabel!
    
    // MARK: ViewDidLoad
    
    /** Register notification center for view controller */
    func registerNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadChatBox"), name: AppDelegateMessage.KeyNotifications.ReloadChatbox.rawValue, object: nil)
    }
    
    
    /** Set data when view did load.
     ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
    func setDataWhenViewDidLoad()
    {
        
        if GET_UserDefaults(dicProfile) == nil
        {
            callAllowUseBluetoothViewController()
        }
    }
    
    /** Set view when view did load
     ** Be there. You can change the layout, view, button,..*/
    func setViewWhenViewDidLoad(){
        setButtonCancelAndDone()
        createFooterView()
    }
    
    
    override func viewDidLoad() {
        registerNotification()
        setDataWhenViewDidLoad()
        setViewWhenViewDidLoad()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    /** Set data when view Will Appear. */
    func setDataWhenWillAppear(){
        
        getListRoom()
     
        setNavigationBar()
    }
    
    /** Begin view WillAppear */
    override func viewWillAppear(animated: Bool)
    {
        setDataWhenWillAppear()
        super.viewWillAppear(animated)
        
    }
    
    func setNavigationBar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Chats"
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: helveticaNeueRegularFontSize(17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
   
        
    }
    
    
    func createFooterView()
    {
        self.footerView = UILabel(frame: FRAME(0, y: 0, w: self.tableData.width, h: 45))
        self.footerView.backgroundColor = UIColor.clearColor()
        self.footerView.textColor = UIColor.blackColor()
        self.footerView.font = helveticaNeueRegularFontSize(14)
        self.footerView.textAlignment = .Center
        self.tableData.tableFooterView = self.footerView
        
    }
    
    
    func setButtonCancelAndDone()
    {
       /* if(self.listRoom!.count > 0){
            let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Delete All", style: UIBarButtonItemStyle.Done, target: self, action: Selector("delete_Pressed"))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Done, target: self, action: Selector("add_Pressed"))
        self.navigationItem.rightBarButtonItem = doneButton
        */
    }
    
    
    func callAllowUseBluetoothViewController()
    {
        let master:MasterNavigation! = self.storyboard?.instantiateViewControllerWithIdentifier("MasterNavigationAllow") as! MasterNavigation
        self.navigationController?.presentViewController(master, animated: false, completion: nil)
        
        
    }
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK: controls button navigation bar
    
    /*func delete_Pressed()
    {
        let alert = UIAlertController(title: "Confirm", message:"Are you sure want to delete all your chat history?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default) { _ in

            self.deleteAllRoom()
            self.setButtonCancelAndDone()
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    func add_Pressed()
    {
        
    }*/
    
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK: Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listRoom.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ListRoomCell = tableView.dequeueReusableCellWithIdentifier("ListRoomCell") as! ListRoomCell
        
        let room = self.listRoom[indexPath.row] as! RoomObject
        let array = room.nameAnother.componentsSeparatedByString(",")
        cell.lbName.text = array.first

        
        //-- find a last message and set into the UI
        let chatModel = ChattingModel()
        let listChatting = chatModel.getChattingByPeripheralID(room.uIIDAnother, name: room.nameAnother)
        if listChatting.count > 0 {
        let lastMessageChat = listChatting.firstObject as! BCMessage
            cell.lbLastMsg.text =  lastMessageChat.message
            cell.lbLastTime.text = lastMessageChat.timestamp
        }

        let image = UIImage(named: "avatar_profile")
        cell.imgAvatar.image = image;
        cell.imgRead.layer.cornerRadius = 6

        let isUnRead = chatModel.getChattingUnreadByPeripheralID(room.uIIDAnother)
        if isUnRead.count > 0
        {
            cell.imgRead.hidden = false
            cell.paddingLeftLbName.constant = 30
        }
        else{
            cell.imgRead.hidden = true
            cell.paddingLeftLbName.constant = 10
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // handle delete (by removing the data from your array and updating the tableview)
            let room = self.listRoom[indexPath.row] as! RoomObject
            deleteRoomByID(room.uIIDAnother)
            
            if self.listRoom.count > 0 {
                self.listRoom.removeObjectAtIndex(indexPath.row)
            }
            self.tableData.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let room = self.listRoom[indexPath.row] as! RoomObject
        let chatViewController =  BCChatViewController()
        chatViewController.idRoom = room.uIIDAnother
        chatViewController.nameToUser  = room.nameAnother
        
        //--update database to readl all
        let chatModel = ChattingModel()
        chatModel.updateStatusReadAll(room.uIIDAnother)
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ListRoomViewController {
 
    // Delete a room by ID
    func deleteRoomByID(idRoom: String) {
        
        let roomModel = RoomModel()
        roomModel.deleteARoom(idRoom)
        
        let chatModel = ChattingModel()
        chatModel.deleteChatting(idRoom)
        
    }
    
    func getListRoom() {
        let roomModel = RoomModel()
        self.listRoom = roomModel.getAllRoom()
        setItemsCount()
        self.tableData.reloadData()
        
    }
    func setItemsCount()
    {
        if self.listRoom == nil || self.listRoom?.count == 0
        {
            self.footerView.height = 45
            self.footerView.text = "Don't have any rooms"
        }
        else{
            self.footerView.height = 0
            self.footerView.text = ""
        }
        self.tableData.tableFooterView = self.footerView
    }
    
}

extension ListRoomViewController {


    func reloadChatBox() {
    
    // Retrieve cached messages from local database
        getListRoom()

    }
}

