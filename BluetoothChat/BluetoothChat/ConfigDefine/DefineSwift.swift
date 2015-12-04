//
//  DefineSwift.swift
//  SecurityFacebook
//
//  Created by Duc Nguyen on 7/15/15.
//  Copyright (c) 2015 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit


struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPHONE         = UIDevice.currentDevice().userInterfaceIdiom == .Phone
    
    static let IS_IPHONE_4_AND_5  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MIN_LENGTH == 320
    
  
}

struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.currentDevice().systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}

func getImageName(nameImage: String)->String{
    if DeviceType.IS_IPAD{
       return nameImage + "_ipad"
    }
    else if DeviceType.IS_IPHONE_6P
    {
        return nameImage + "_plus"
    }
    else if DeviceType.IS_IPHONE_6
    {
       return nameImage + "_6"
    }
    return nameImage
}



func getFontSize(fontsize: CGFloat) -> CGFloat{
    if DeviceType.IS_IPAD{
        return fontsize * 1.5
    }
    return fontsize * ScreenSize.SCREEN_WIDTH/414
}

func RGB(r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor
{
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat, c:CGFloat) ->UIColor
{
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: c)
}

func FRAME_SWF(x:Float,y:Float,w:Float,h:Float) -> CGRect{
    
    return CGRectMake(x.f, y.f, w.f, h.f)
}

func FRAME(x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat) -> CGRect{
    
    return CGRectMake(x, y, w, h)
}

func SET_UserDefaults(value:AnyObject,keyValue:String)
{
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(value, forKey: keyValue)
    defaults .synchronize()
}

func SET_IntUserDefaults(value:Int,keyValue:String)
{
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(value, forKey: keyValue)
    defaults .synchronize()
}

func GET_IntUserDefaults(keyValue:String)->Int
{
    let defaults = NSUserDefaults.standardUserDefaults()
    return defaults.integerForKey(keyValue)
}


func GET_UserDefaults(keyValue:String)->AnyObject?
{
    let defaults = NSUserDefaults.standardUserDefaults()
    let object: AnyObject? = defaults.objectForKey(keyValue)
    return object
}


func GET_BoolUserDefaults(keyValue:String)->Bool
{
    let defaults = NSUserDefaults.standardUserDefaults()
    let object = defaults.boolForKey(keyValue)
    return object
}

func SET_BoolUserDefaults(value:Bool,keyValue:String)
{
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(value, forKey: keyValue)
    defaults .synchronize()
}


// MARK: Font Size

func helveticaNeueMediumFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name: "HelveticaNeue-Medium", size: fontSize)!
}

func helveticaNeueBoldFontSize(fontSize: CGFloat)-> UIFont
{

    return UIFont(name: "HelveticaNeue-Bold", size: fontSize)!
}


func helveticaNeueCondensedBoldFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name: "HelveticaNeue-CondensedBold", size: fontSize)!
}


func helveticaNeueRegularFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"HelveticaNeue", size: fontSize)!
}


func helveticaNeueLightFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name: "HelveticaNeue-Light", size: fontSize)!
}

func myriadProSemiboldFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name: "MyriadPro-Semibold", size: fontSize)!
}

func myriadProRegularFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name: "MyriadPro-Regular", size: fontSize)!
}



////////////////////////////////////////////////////////////////////////////////

func robotoCondensedRegularFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"RobotoCondensed-Regular", size: fontSize)!
}

func robotoCondensedLightFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"RobotoCondensed-Light", size: fontSize)!
}


func robotoLightFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"Roboto-Light", size: fontSize)!
}


func robotoRegularFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"Roboto-Regular", size: fontSize)!
}


func ptSansNarrowBoldFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"PTSans-NarrowBold", size: fontSize)!
}

func ptSansNarrowFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"PTSans-Narrow", size: fontSize)!
}

func ptSansRegularFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"PTSans-Regular", size: fontSize)!
}



func ptSansBoldFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"PTSans-Bold", size: fontSize)!
}


func ptSansCaptionFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"PTSans-Caption", size: fontSize)!
}

func cantarellRegularFontSize(fontSize: CGFloat)-> UIFont
{
    return UIFont(name:"Cantarell-Regular", size: fontSize)!
}

func fixImageOrientation(src:UIImage)->UIImage {
    
    if src.imageOrientation == UIImageOrientation.Up {
        return src
    }
    
    var transform: CGAffineTransform = CGAffineTransformIdentity
    
    switch src.imageOrientation {
    case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
        transform = CGAffineTransformTranslate(transform, src.size.width, src.size.height)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        break
    case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
        transform = CGAffineTransformTranslate(transform, src.size.width, 0)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        break
    case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, src.size.height)
        transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        break
    case UIImageOrientation.Up, UIImageOrientation.UpMirrored:
        break

    }
    
    switch src.imageOrientation {
    case UIImageOrientation.UpMirrored, UIImageOrientation.DownMirrored:
        CGAffineTransformTranslate(transform, src.size.width, 0)
        CGAffineTransformScale(transform, -1, 1)
        break
    case UIImageOrientation.LeftMirrored, UIImageOrientation.RightMirrored:
        CGAffineTransformTranslate(transform, src.size.height, 0)
        CGAffineTransformScale(transform, -1, 1)
    case UIImageOrientation.Up, UIImageOrientation.Down, UIImageOrientation.Left, UIImageOrientation.Right:
        break

    }
    
    let colorSpace:CGColorSpace = CGImageGetColorSpace(src.CGImage)!
    
    let ctx:CGContextRef = CGBitmapContextCreate(nil, Int(src.size.width), Int(src.size.height), CGImageGetBitsPerComponent(src.CGImage), 0,colorSpace, CGImageGetBitmapInfo(src.CGImage).rawValue )!
    CGContextConcatCTM(ctx, transform)
    
    switch src.imageOrientation {
    case UIImageOrientation.Left, UIImageOrientation.LeftMirrored, UIImageOrientation.Right, UIImageOrientation.RightMirrored:
        CGContextDrawImage(ctx, CGRectMake(0, 0, src.size.height, src.size.width), src.CGImage)
        break
    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, src.size.width, src.size.height), src.CGImage)
        break
    }
    
    let cgimg:CGImageRef = CGBitmapContextCreateImage(ctx)!
    let img:UIImage = UIImage(CGImage: cgimg)
    
    return img
}



func openAppURL(appleID:Int!)
{
    let localeLanguages :NSArray! = NSLocale.preferredLanguages() as NSArray
    let location :String! = localeLanguages.objectAtIndex(0) as! String
    let appURL =  String(format: "itms-apps://itunes.apple.com/%@/app/id%@",location,String(appleID))
    UIApplication.sharedApplication().openURL(NSURL(string: appURL)!)
}


func getStoryBoard(type:Int!)->UIStoryboard{
    if type == 0
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    else if type == 1
    {
        return UIStoryboard(name: "Main_1", bundle: nil)
    }
    return UIStoryboard(name: "Main_2", bundle: nil)
}

func getTimeIntervalSince1970()-> Double
{
    let now: Double = NSDate().timeIntervalSince1970
    //let now: Double = NSDate().dateByAddingTimeInterval(Double(NSTimeZone.systemTimeZone().secondsFromGMT)).timeIntervalSince1970
    //let now: Double = NSDate().timeIntervalSince1970  + Double(NSTimeZone.systemTimeZone().secondsFromGMT)
    return now
}


struct MyConstraint {
    static func changeMultiplier(constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)
        
        if Version.iOS8 {
            NSLayoutConstraint.deactivateConstraints([constraint])
        } else {
            // Fallback on earlier versions
        }
        if Version.iOS8 {
            NSLayoutConstraint.activateConstraints([newConstraint])
        } else {
            // Fallback on earlier versions
        }
        
        return newConstraint
    }
}
