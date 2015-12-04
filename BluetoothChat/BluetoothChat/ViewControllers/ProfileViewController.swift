//
//  ProfileViewController.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit

let firstName:String = "firstname"
let lastName:String = "lastname"
class ProfileViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProfile: UIButton!
    @IBOutlet weak var viewAllContent: UIView!
    
    @IBOutlet weak var paddingLeftLineTwo: NSLayoutConstraint!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!

    @IBOutlet weak var btSwitch: UISwitch!
    @IBOutlet weak var heightViewAllContent: NSLayoutConstraint!
    @IBOutlet weak var viewPicture: UIView!
    @IBOutlet var collectionOfLineView: Array<UIView>?
    @IBOutlet var collectionViewNoti: Array<UIView>?
    var activeField:UITextField!
    var selectedImage : UIImage!
    var isEdit : Bool  = false
    var dicProFile : NSDictionary!
    var isFrist:Bool = false
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK: ViewDidLoad
    
    /** Register notification center for view controller */
    func registerNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidAppear:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterFromKeyboardNotifications()
    }
    
    func unregisterFromKeyboardNotifications () {
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardDidAppear(aNotification:NSNotification!) {
        
        let info : NSDictionary = aNotification.userInfo!
        let kbSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue as CGRect!).size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height;
        if self.activeField != nil
        {
            if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
                self.scrollView.scrollRectToVisible(self.activeField.frame, animated: true)
            }
            
        }
        
    }
    
    func keyboardWillHide(aNotification:NSNotification!)  {
        
        let contentInsets :UIEdgeInsets! = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        
    }
    
    /** Set data when view did load.
     ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
    func setDataWhenViewDidLoad()
    {
        if(self.isFrist == true)
        {
            self.isEdit = true
            
        }
        else
        {
            getDataFromUserDefaults()
            setFirstAndLastName()
        }
        
        self.txtFirstName.autocapitalizationType = UITextAutocapitalizationType.Words
        self.txtLastName.autocapitalizationType = UITextAutocapitalizationType.Words

    }
    
    /** Set view when view did load
     ** Be there. You can change the layout, view, button,..*/
    func setViewWhenViewDidLoad(){
        
        setNavigationBar()
        setButtonNavigation()
        setLineViewTextField()
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setStateNotification"), name: UIApplicationDidBecomeActiveNotification, object: nil)
        setStateNotification()
    }
    

    
    /** Begin view WillAppear */
    override func viewWillAppear(animated: Bool)
    {
        setDataWhenWillAppear()
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Remove observer:
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name:UIApplicationDidBecomeActiveNotification,
            object:nil)
    }
    
    func setNavigationBar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Profile"
        
        //UIBarButtonItem.appearance().tintColor = UIColor.redColor()
        //self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: helveticaNeueRegularFontSize(17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
  
        
    }
    
    func setButtonNavigation()
    {
        
        if(self.isEdit)
        {
            setButtonCancelAndDone()
        }
        else
        {
            setButtonEdit()
        }
        setTextAndViewNormal()
    }
    
    func setButtonCancelAndDone()
    {
        if(self.isFrist == false)
        {
            let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: Selector("cancel_Pressed"))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        else
        {
            let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("saveEditProfile_Pressed"))
        self.navigationItem.rightBarButtonItem = doneButton
        
    }
    
    func setButtonEdit()
    {
        let editButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Done, target: self, action: Selector("editProfile_Pressed"))
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
// MARK: controls button Navigation Bar
    
    func editProfile_Pressed()
    {
        self.isEdit = true
        self.setButtonNavigation()
    }
    
    func saveEditProfile_Pressed()
    {
        //check validTextField empty or not
        if checkValidTextField() == true
        {
            saveDataEditToUserDefaults()
            
            self.isEdit = !self.isEdit
            self.setButtonNavigation()
            
            if(self.isFrist == true)
            {
                self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    func cancel_Pressed()
    {
        Common.globalResignFirstResponder()
        setFirstAndLastName()
        self.isEdit = !self.isEdit
        self.setButtonNavigation()
        
    }
    
    
// /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
// MARK: Model
    
    func setFirstAndLastName()
    {
        if((self.dicProFile[firstName]) != nil)
        {
            self.txtFirstName.text = self.dicProFile[firstName] as? String
        }
        if((self.dicProFile[lastName]) != nil)
        {
            self.txtLastName.text = self.dicProFile[lastName] as? String
        }
    }
    
    func saveDataEditToUserDefaults()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var dic = [String: String]()
    
        let firstNameStr = self.txtFirstName.text!
        let lastNameStr = self.txtLastName.text!
        
        dic[firstName] = firstNameStr
        dic[lastName] = lastNameStr
        
        
        userDefaults.setObject(dic, forKey: dicProfile)
        
        // Notification to others
        let fullName = firstNameStr + " " + lastNameStr
        let oldName = BCDefaults.stringForKey(.Name)
        
        if BCDefaults.stringForKey(.Name) == nil {
            
            BCDefaults.setObject(fullName, forKey: .Name)
            Common.getAppDelegate().peripheralManager.sendName()
        }else {
            
            BCDefaults.setObject(fullName, forKey: .Name)
            Common.getAppDelegate().peripheralManager.sendName(isSelf: true, oldName: oldName)
        }
    }
    
    func getDataFromUserDefaults()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.dicProFile = userDefaults.dictionaryForKey(dicProfile)
    }
    
    func setTextAndViewNormal()
    {
        if(self.isEdit)
        {
            self.txtFirstName.enabled = true
            self.txtLastName.enabled = true
            self.txtFirstName.becomeFirstResponder()
        }
        else
        {
            self.txtFirstName.enabled = false
            self.txtLastName.enabled = false
        }
    }
    
    func setLineViewTextField()
    {
        
        var value:CGFloat = 1.0
        if UIScreen.mainScreen().respondsToSelector(Selector("scale")) == true && UIScreen.mainScreen().scale == 2.0
        {
            value = 0.5
        }
        else{
            value = 0.33
        }
        for viewLine in self.collectionOfLineView!{
            viewLine.backgroundColor = UIColor.clearColor()
            Common.addTopBorderWithColor(RGBA(127, g: 127, b: 127, c: 0.4), andWidth: value, andView: viewLine)
        }
        if self.isFrist == true
        {
            for view in self.collectionViewNoti!
            {
                view.hidden = true
            }
            self.paddingLeftLineTwo.constant = 0
        }
     
        
    }
    
    func checkValidTextField()->Bool
    {
        
        trimString(self.txtFirstName)
        if self.txtFirstName.text!.length == 0 || self.txtFirstName.text!.length > 150
        {
            showAlertView("Please enter your first Name and don't type over 20 characters")
            return false
        }
        
        trimString(self.txtLastName)
        if self.txtLastName.text!.length == 0 || self.txtLastName.text!.length > 150
        {
            showAlertView("Please enter your last Name and don't type over 20 characters")
            return false
        }
        
        
        return true
    }
    
    func trimString(textField:UITextField!)
    {
        textField.text =  textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
        textField.text =  textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceAndNewlineCharacterSet())
    }
    
    func showAlertView(text: String!)
    {
        let alert = UIAlertController(title: "", message:text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK:textField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        self.activeField = textField
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        trimString(textField)
        self.activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if txtFirstName == textField{
            txtLastName.becomeFirstResponder()
        }
        else{
            self.saveEditProfile_Pressed()
        }
        return true
    }
    
    /* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇*/
    // MARK:btSwitch_Changed 
    
    
    @IBAction func btSwitch_Changed(sender: AnyObject)
    {
        if self.btSwitch.on == true
        {
            if UIApplication.sharedApplication().currentUserNotificationSettings()?.hashValue == 0{
                self.btSwitch.on = false
                let alertController = UIAlertController(title: "Alert", message: "Please turn on push notifications in your device settings", preferredStyle:UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                    { action -> Void in
                        // Put your code here
                    })
                self.presentViewController(alertController, animated: true, completion: nil)
  
            }
            else{
                SET_BoolUserDefaults(true, keyValue: kNotification)
            }
        }
        else{
            SET_BoolUserDefaults(false, keyValue: kNotification)
        }
       
    }
    
    
    func setStateNotification()
    {
        if GET_BoolUserDefaults(kNotification)
        {
            if UIApplication.sharedApplication().currentUserNotificationSettings()?.hashValue != 0{
                self.btSwitch.on = true
            }
            else{
                self.btSwitch.on = true
            }
            
        }
        else{
            self.btSwitch.on = false
        }
    }
}
