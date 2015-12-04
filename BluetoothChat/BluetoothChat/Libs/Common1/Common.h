//
//  Common.h
//  


//
//  Created by Duc Nguyen on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@class AppDelegate;
//#import "GDataLibrary.h"

typedef enum {
    kPlatformIpad = 0,
    kPlatformNormallyiPhone = 1,
    kPlatformNormallyiPhone5 = 2,
    kPlatformN_A = -1,
} kTypePlatform;




@interface Common : NSObject


+(void) setOrientation:(NSString *) orientation;
+(NSString *) getOrientation;


+ (NSString*) documentsPath;
+(BOOL)shouldAutorotateToInterfaceOrientationPortrait:(UIInterfaceOrientation)interfaceOrientation;


+ (NSString *) getImageName:(NSString *) name;
+ (NSString *) getImageNameBackground:(NSString *) name;
//--get uuid
-(NSString *) makeUUID;

//--Get info device and apps
-(NSString *) infoAppName;


//--Validate Email
+(BOOL) validateEmail:(NSString *)originalString;

//--Check network wifi and wlan
+(BOOL) checkNetWork;

+ (BOOL) validatePhone: (NSString *) aMobile;

+(NSString *)urlEncodeUsingEncoding:(NSString *) keyword;
+ (NSString *)extractNumberFromText:(NSString *)text;

+(AppDelegate *) getAppDelegate;

-(BOOL) allowGoogleAdmob;


//--formatdate from string to date
+(NSString *) formatStringFromDate:(NSString *) formattedString;


//- (NSString *)dateUS:(NSString *) dateStr;

//--+(void) reduceNumberBadgeApp;
//--+(void) reduceNumber:(int) numberBadge;

+ (NSString*)parseISO8601Time:(NSString*)duration;
+ (NSString *)normalizeString:(NSString *)unprocessedValue;

//////////////////////////////////////////////////////////////////
+(NSString *) returnFileNameWithoutTheExtension:(NSString *)fileName;

+ (NSString *) getViewCount:(NSInteger ) money;
//////////////////////////////////////////////////////////////////
+(NSString *) returnMusicTimeFormatWithValue: (float)value;
+(NSString *) formatDateFromString5:(NSTimeInterval ) seconds;
+(NSString *) formatDateFromDate9:(NSDate *) date;
+(NSString *) formatDateFromDate7:(NSDate *) date; //-- co dung
+(NSDate *) formatDateFromString6:(NSString *) formattedString; //-- co lun
+(NSString *) formatDateFromDate3:(NSDate *) date; //-- co dung;
+(NSString *) formatDateFromString4:(NSString *) formattedString; //-- co lun
+(NSString *) formatStringFromDate2:(NSString *) formattedString;
+(NSString *) formatStringFromDate1:(NSString *) formattedString;
+(NSString *) formatDateFromString8:(NSDate *) date;
+(NSString*)HourCalculation:(NSString*)PostDate;
+ (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd;
+ (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd;
+ (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd;
+ (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd;
+(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
+(kTypePlatform) checkPlatform;
+(NSString *) checkDevice:(NSString *)viewFirstName;
+(NSString *) checkDeviceOption:(NSString *)viewFirstName;
+(NSString *) getStoryboard;
+ (NSString *)appSupportDir;
+ (NSString *)cacheDir;
+ (void)initDirectory;
+ (NSString *)mediaRootDir;
+ (NSString *)documentDir;
+ (NSString *)rootDir;
+ (NSString *)tempDir;
+ (NSString *)downloadDir;
+ (NSString *)inboxDir;
+(NSString*)sha256HashFor:(NSString*)input;
+(BOOL) checkNetWorkAndAlert;

+(UIImage *) imageWithColor:(UIColor *)color;
+(UIImage *) imageWithColor1:(UIColor *)color andSize:(CGSize) size;
+(UIImage *)makeRoundedImage:(UIColor *) color sizeObject:(CGSize) sizeObject radius: (float) radius;
+ (void) makeCornerTopOrBotton:(UIButton *) button andTop:(BOOL) isTop;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSString*) dbPath;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+(BOOL)checkIfDirectoryAlreadyExists:(NSString *)path;
+ (void) globalResignFirstResponder;




+(void) showAlert:(NSString *) title andMessage:(NSString *) message andtitleButton:(NSString *) tittleButton;

@end
