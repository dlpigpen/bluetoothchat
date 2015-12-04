//
//  Helper.h
//  Lock-Clock
//
//  Created by Vuong Nguyen on 1/8/14.
//  Copyright (c) 2014 Vuong Nguyen. All rights reserved.
//
#import "Common.h"
#import "UIView+Frame.h"
#import "UIImage+Utility.h"
#import <Foundation/Foundation.h>
#import "Config.h"
#import "UIDevice+SystemVersion.h"
#import "UIBarButtonItem + WithImageOnly.h"
#import "UIImage+ProportionalFill.h"
#import "UIImage+Tint.h"
#import "UIBarButtonItemCustom.h"


#import "UIImageView+Render.h"
#import "MasterNavigation.h"


#import "NSDate+Utilities.h"
#import "SVPullToRefresh.h"
#import "UITextView+Placeholder.h"
#import "UIAlertView+Blocks.h"
#import "FMDB.h"
#import "ModelManager.h"
#define URL(urlString) [NSURL URLWithString:urlString]


#define F(string, args...) [NSString stringWithFormat:string, args]


#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title\
                            message:msg\
                            delegate:nil\
                            cancelButtonTitle:@"OK"\
                            otherButtonTitles:nil] show]


#define SYSTEM_VERSION_EQUAL_TO_OR_GREATER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define FRAME(x, y, w, h) CGRectMake(x, y, w, h)



#define SET_UserDefaults(value, key) [[NSUserDefaults standardUserDefaults] setObject:(value) && ![(value) isEqualToString:@""] ? (value) : NULL forKey:(key)]

#define UserDefaults(param) [[NSUserDefaults standardUserDefaults] objectForKey:(param)]


#define Bool_UserDefaults(param) [[NSUserDefaults standardUserDefaults] boolForKey:(param)]


#define Int_UserDefaults(param) [[NSUserDefaults standardUserDefaults] integerForKey:(param)]


#define Remove_UserDefaults(param) [[NSUserDefaults standardUserDefaults] removeObjectForKey:(param)]


#define GOBACK [self.navigationController popViewControllerAnimated:YES]


#define DELEGATE_OK(delegateMethod) [self.delegate respondsToSelector:@selector(delegateMethod)]

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) \
|| ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) \
? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define NAVBAR_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) \
|| ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? 44.f : 32.f)

#define TOOLBAR_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) \
|| ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? 49.f : 32.f)


#define MB_IMAGE(name) ([UIImage imageNamed:[NSString stringWithFormat:@"%@", (name)]])
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)


#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)


//#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]



#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)

#define RELEASE_TO_NIL(obj) if(obj != nil) { [obj release]; obj = nil; }

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_LESS_THAN_OS_7   ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define IS_LESS_THAN_OS_8   ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
