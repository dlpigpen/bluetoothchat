//
//  ConnectionViewController.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit

enum StateBluetoothDevice
{
    case TurnOffBluetoothDevice
    case TurnOnBluetoothDevice
}

enum StateRadar
{
    case TurnOffRadar
    case TurnOnRadar
}

class ConnectionViewController: UIViewController {
    
    
    // MARK: - Properties
    @IBOutlet weak var tableData: UITableView!
    var buttonTurnOnOff:UIButton!
    var listConnection:[NSUUID: String] = [:]
    var stateBluetoothDevice:StateBluetoothDevice = .TurnOnBluetoothDevice
    var stateRadar:StateRadar = .TurnOnRadar
    
    
   // MARK: Method launching a view controller
    
    /** Register notification center for view controller */
    func registerNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateList"), name: AppDelegateMessage.KeyNotifications.UpdateList.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateList"), name: AppDelegateMessage.KeyNotifications.UserLeft.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didStartScanningConnection"), name: AppDelegateMessage.KeyNotifications.StartScanning.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didFinishScanningConnection"), name: AppDelegateMessage.KeyNotifications.FinishScanning.rawValue, object: nil)
        
    }
    
    /** Set data when view did load.
     ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
    func setDataWhenViewDidLoad()
    {
        self.listConnection =  Common.getAppDelegate().chatroomUsers
        self.tableData .reloadData()
        //setTurnOnOFFBluetoothItemBar()
        
    }
    
    /** Set view when view did load
     ** Be there. You can change the layout, view, button,..*/
    func setViewWhenViewDidLoad(){
        
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
      
        setNavigationBar()
        setHeaderTableStateConnection()

    }
    
    /** Begin view WillAppear */
    override func viewWillAppear(animated: Bool)
    {
        setDataWhenWillAppear()
        super.viewWillAppear(animated)
        
    }
    
    /** Update navigation with some customize **/
    func setNavigationBar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Connection"
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: helveticaNeueRegularFontSize(17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
      
    }
    
    
    func setTurnOnOFFBluetoothItemBar()
    {
    
        self.buttonTurnOnOff  = UIButton(type: UIButtonType.Custom)
        self.buttonTurnOnOff.frame = FRAME(0, y: 0, w: 44, h: 44)

        setImageTurnOnOFFBluetoothItemBar()
        self.buttonTurnOnOff.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        self.buttonTurnOnOff.addTarget(self, action: Selector("scannerButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        let backBarButtonItem = UIBarButtonItemCustom(customUIButton: self.buttonTurnOnOff)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func setImageTurnOnOFFBluetoothItemBar()
    {
        /*if  self.stateRadar == .TurnOnRadar //-- is Turn ON
        {
            self.buttonTurnOnOff.setImage(UIImage(named: "bluetooth_small"), forState: UIControlState.Normal)
        }
        else{ //-- is Turn OFF
            self.buttonTurnOnOff.setImage(UIImage(named: "radar_nearby"), forState: UIControlState.Normal)
        }*/
        setHeaderTableStateConnection()
    }
    

    func setHeaderTableStateConnection()
    {
        if self.stateRadar == .TurnOnRadar
        {
            if self.stateBluetoothDevice == .TurnOnBluetoothDevice{
                setHeaderTableTurnOnRadar()
            }
            else{
                setHeaderTableTurnOffBluetoothDevice()
            }
        }
        else{
            if self.stateBluetoothDevice == .TurnOnBluetoothDevice{
                setHeaderTableTurnOffRadar()
            }
            else{
                setHeaderTableTurnOffBluetoothDevice()
            }
        }
        self.tableData.reloadData()
    }
    
    
    func setHeaderTableTurnOffBluetoothDevice()
    {
        let cell:StateConnectionCell = self.tableData.dequeueReusableCellWithIdentifier("BluetoothIsOff") as! StateConnectionCell
        cell.tag = 1
        cell.contentView.backgroundColor = RGBA(127, g: 127, b: 127, c: 0.1)
        while ((cell.contentView.gestureRecognizers?.count) == 0)
        {
            cell.contentView.removeGestureRecognizer(cell.contentView.gestureRecognizers![0])
        }
        self.tableData.tableHeaderView = cell.contentView
    }
    
    func setHeaderTableTurnOnRadar()
    {
        let cell:StateConnectionCell = self.tableData.dequeueReusableCellWithIdentifier("ScanTheRoom") as! StateConnectionCell
        cell.imgScan.rotate360Degrees()

        cell.contentView.backgroundColor = RGBA(127, g: 127, b: 127, c: 0.1)
        while ((cell.contentView.gestureRecognizers?.count) == 0)
        {
            cell.contentView.removeGestureRecognizer(cell.contentView.gestureRecognizers![0])
        }
        self.tableData.tableHeaderView = cell.contentView
    }
    
    
    func setHeaderTableTurnOffRadar()
    {
        //self.tableData.tableHeaderView =  UIView(frame: FRAME(0,y: 0,w: self.tableData.bounds.size.width,h: 0.001))
        
        let cell:StateConnectionCell = self.tableData.dequeueReusableCellWithIdentifier("OffTheRadarMode") as! StateConnectionCell
          cell.contentView.backgroundColor = RGBA(127, g: 127, b: 127, c: 0.1)
        while ((cell.contentView.gestureRecognizers?.count) == 0)
        {
            cell.contentView.removeGestureRecognizer(cell.contentView.gestureRecognizers![0])
        }
        cell.btAction .addTarget(self, action: Selector("scannerButtonPressed:"), forControlEvents: .TouchUpInside)
        
       self.tableData.tableHeaderView = cell.contentView
    }
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK: Table

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listConnection.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ListRoomCell = tableView.dequeueReusableCellWithIdentifier("ListRoomCell") as! ListRoomCell
        
        let keys = Array(self.listConnection.keys)
        let name = self.listConnection[keys[indexPath.row]]
        
        let array = name?.componentsSeparatedByString(",")
        cell.lbName.text = array?.first
        cell.idDevice = array?.last
        
        let image = UIImage(named: "avatar_profile")
        cell.imgAvatar.image = image;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // pass parameters idRoom, nameToUser
        let cell = self.tableData.cellForRowAtIndexPath(indexPath) as! ListRoomCell
        
        let keys = Array(self.listConnection.keys)
        let peripheral = keys[indexPath.row]
        let name  = self.listConnection[peripheral]
        
        let chatViewController =  BCChatViewController()
        chatViewController.idRoom = cell.idDevice
        chatViewController.nameToUser  = name
        
        /*print("Key id Room:",  chatViewController.idRoom)
        print("Name To User id Room:",  chatViewController.nameToUser)*/
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ConnectionViewController {
    
    // Process when receive a notification update list
    func updateList() {
        self.listConnection = Common.getAppDelegate().chatroomUsers
        self.tableData.reloadData()
        
    }
}

extension ConnectionViewController {
    
    // Update when press on the scanner button
    func scannerButtonPressed(sender: AnyObject)
    {
        Common.getAppDelegate().scanPeripheral()

    }
    
    func didStartScanningConnection() {
        self.stateRadar = .TurnOnRadar
        setImageTurnOnOFFBluetoothItemBar()
    }
    
    func didFinishScanningConnection() {
        self.stateRadar = .TurnOffRadar
        setImageTurnOnOFFBluetoothItemBar()
    }
    
}

extension ConnectionViewController {
    override func viewWillDisappear(animated: Bool) {
        
       Common.getAppDelegate().stopPeripheral()
        
        super.viewWillDisappear(animated)
    }
}