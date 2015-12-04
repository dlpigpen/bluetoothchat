//
//  ViewController.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//
import UIKit
class AllowUseBluetoothViewController: UIViewController {
    
    @IBOutlet weak var btAllow: UIButton!
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK: ViewDidLoad
    
    /** Register notification center for view controller */
    func registerNotification()
    {

    }
    
    /** Set data when view did load.
     ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
    func setDataWhenViewDidLoad()
    {
   
        self.btAllow.layer.cornerRadius = 10
        self.btAllow.clipsToBounds = true
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkUserNotificationSettings"), name: "didRegisterUserNotificationSettings", object: nil)
        setNavigationBar()
    }
    
    /** Begin view WillAppear */
    override func viewWillAppear(animated: Bool)
    {
        setDataWhenWillAppear()
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "didRegisterUserNotificationSettings", object: nil)
    }
    
    func setNavigationBar()
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.title = ""
        
        //UIBarButtonItem.appearance().tintColor = UIColor.redColor()
        //self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: helveticaNeueRegularFontSize(17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    
        
    }
    
    @IBAction func btAllow_Pressed(sender: AnyObject) {
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert , .Badge , .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
      
        
       
    }
    
    func checkUserNotificationSettings()
    {
        if UIApplication.sharedApplication().currentUserNotificationSettings()?.hashValue == 0{
            SET_BoolUserDefaults(false, keyValue: kNotification)
        }
        else{
            SET_BoolUserDefaults(true, keyValue: kNotification)
        }
        let profileView:ProfileViewController!  = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as!ProfileViewController
        profileView.isFrist = true
        self.navigationController?.pushViewController(profileView, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

