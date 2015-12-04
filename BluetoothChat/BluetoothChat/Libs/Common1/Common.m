//
//  Common.m
//  AttackByTurniPhoneGame
//
//  Created by Duc Nguyen on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"

#include <sys/xattr.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation Common


#pragma mark - Check Platform


+(AppDelegate *) getAppDelegate
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return app;
}



+(BOOL)shouldAutorotateToInterfaceOrientationPortrait:(UIInterfaceOrientation)interfaceOrientation
{
    
 
    if (interfaceOrientation == UIInterfaceOrientationPortrait ||
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
}



+(kTypePlatform) checkPlatform
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return kPlatformIpad;
    else{
      
        CGSize sizeScreen  = [UIScreen mainScreen].bounds.size;
               // NSLog(@"size screen: %@", NSStringFromCGSize(sizeScreen));
        if (sizeScreen.height == 568.0f)
            return kPlatformNormallyiPhone5;
        else
            
            return kPlatformNormallyiPhone;
    }
    
    return kPlatformN_A;
}

+ (NSString *) getImageNameBackground:(NSString *) name
{
    if (IS_IPAD)
    {
        name = [NSString stringWithFormat:@"%@_ipad", name];
    }
    else if (IS_IPHONE_6_PLUS)
    {
        name = [NSString stringWithFormat:@"%@_plus", name];
    }
    else if (IS_IPHONE_6)
    {
        name = [NSString stringWithFormat:@"%@_6", name];
    }
    else if (IS_IPHONE_4)
    {
        name = [NSString stringWithFormat:@"%@_iphone4", name];
    }
    return name;
}


+ (NSString *) getImageName:(NSString *) name
{
    if (IS_IPAD)
    {
        name = [NSString stringWithFormat:@"%@_ipad", name];
    }
    else if (IS_IPHONE_6_PLUS)
    {
        name = [NSString stringWithFormat:@"%@_plus", name];
    }
    else if (IS_IPHONE_6)
    {
        name = [NSString stringWithFormat:@"%@_6", name];
    }
    return name;
}


+(NSString *) checkDevice:(NSString *)viewFirstName{
    NSString *viewName=@"";
    if (IS_IPHONE_4) {
         viewName = [NSString stringWithFormat:@"iphone4%@", viewFirstName];
    }
    else{
        viewName = viewFirstName;
    }
    return viewName;
}


+(NSString *) checkDeviceOption:(NSString *)viewFirstName{
    NSString *viewName=@"";
    kTypePlatform typePlatform = [Common checkPlatform];
    switch (typePlatform) {
            
        case kPlatformNormallyiPhone5:
        {
            viewName = [NSString stringWithFormat:@"%@", viewFirstName];
        }
            break;
        case kPlatformNormallyiPhone:
        {
            viewName = [NSString stringWithFormat:@"Iphone%@", viewFirstName];
        }
            
            break;
        case kPlatformIpad:
        {
            viewName = [NSString stringWithFormat:@"%@", viewFirstName];
        }
            
            break;
        default:
            break;
    }
    
    return viewName;
}

+(NSString *) getStoryboard
{
    NSString *storyBoardName=@"";
    kTypePlatform typePlatform = [Common checkPlatform];
    switch (typePlatform) {
            
        case kPlatformNormallyiPhone5:
        {
            storyBoardName = @"Main_iPhone";
        }
            break;
        case kPlatformNormallyiPhone:
        {
            storyBoardName = @"Main_iPhone";
        }
            
            break;
        case kPlatformIpad:
        {
            storyBoardName = @"Main_iPad";
        }
            
            break;
        default:
            break;
    }
    
    return storyBoardName;
}



-(BOOL) allowGoogleAdmob
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"allowGoogleAdmob"])
    {
        //--NSLog(@" vao day la sao");
        [defaults setBool:YES forKey:@"allowGoogleAdmob"];
    }

    
    return [defaults boolForKey:@"allowGoogleAdmob"];
}



+(void) setOrientation:(NSString *) orientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:orientation forKey:@"orientation"];
    [defaults synchronize];
}

+(NSString *) getOrientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *orientation = [defaults valueForKey:@"orientation"];
    return orientation;
}




+ (NSString*) documentsPath
{
    NSArray *searchPaths =
    NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* _documentsPath = [searchPaths objectAtIndex: 0];
    
    return _documentsPath;
}



+ (void) makeFolder:(NSString *) nameFolder
{
    
    // Get documents Caches folder
    NSString *documentsDirectory = [self documentsPath];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:nameFolder];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    //Create folder
}




//-------------------------------------------------------
//
+(NSString *)saveToCacheWithFileName: (NSString *)ringtoneName
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString* documentsPath = [[searchPaths objectAtIndex: 0] stringByAppendingString:@"/temp"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
    if (!exists)
    {
        
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        
    }
    
    NSString *saveFolderPath = [documentsPath stringByAppendingPathComponent:ringtoneName];
    
    return saveFolderPath;
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
#pragma mark - DEVICE


//////////////////////////////////////////////////////////////////
-(NSString *) makeUUID
{
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	NSString *deviceUuid;

		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		id uuid = [defaults objectForKey:@"deviceUuid"];
		if (uuid)
			deviceUuid = (NSString *)uuid;
		else {
            CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
            NSString *deviceUuid = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
            CFRelease(uuid);
            
            [defaults setObject:deviceUuid forKey:@"deviceUuid"];
            
            [defaults synchronize];
            return deviceUuid;
   
		}
    
    return deviceUuid;
}



+(NSString *)urlEncodeUsingEncoding:(NSString *) keyword
{
    NSString *trimmedString = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) trimmedString,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'\"();@+$,%#[]% "),
                                                                                                    kCFStringEncodingUTF8));
    
    return escapedString;

}

+ (NSString *)extractNumberFromText:(NSString *)text
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}


+ (NSString *)normalizeString:(NSString *)unprocessedValue
{
    if (!unprocessedValue) return nil;
    
    NSMutableString *result = [NSMutableString stringWithString:unprocessedValue];
    
    CFStringNormalize((CFMutableStringRef)result, kCFStringNormalizationFormD);
    CFStringFold((CFMutableStringRef)result, kCFCompareCaseInsensitive | kCFCompareDiacriticInsensitive | kCFCompareWidthInsensitive, NULL);
    
    
    result = (NSMutableString  *)[result stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    result = (NSMutableString  *) [result stringByReplacingOccurrencesOfString:@"Đ" withString:@"d"];
    
    return result;
}

/////////////////////////////////////////////////////////////////////////////////////////////
//--Get info device and apps
-(NSString *) infoAppName
{
    
#if !DEBUG
    
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
#endif
    return  @"";
}


//////////////////////////////////////////////////////////////////
+(BOOL) validateEmail:(NSString *)originalString
{
    NSString *regexString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regex evaluateWithObject:originalString];
}


//////////////////////////////////////////////////////////////////
/**
 * Check network wifi and wlan
 */
+(BOOL) checkNetWork
{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com.vn"];
    NetworkStatus intenetStatus = [r currentReachabilityStatus];
    
    if ((intenetStatus != ReachableViaWiFi) && (intenetStatus != ReachableViaWWAN))
    {
        return NO;
    }
    return YES;
}


+(BOOL) checkNetWorkAndAlert
{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com.vn"];
    NetworkStatus intenetStatus = [r currentReachabilityStatus];
    
    if ((intenetStatus != ReachableViaWiFi) && (intenetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Network unavailable" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
		[alert show];

        return NO;
    }
    return YES;
}


+ (BOOL) validatePhone: (NSString *) aMobile
{
    return YES;
    //NSString *phoneRegex = @"^(\\([0-9]{3})\\) [0-9]{3}-[0-9]{4}$";
    //NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //return [phoneTest evaluateWithObject:aMobile];
}

+(NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


//////////////////////////////////////////////////////////////////
//--format date from date to string
+(NSString *) formatDateFromString5:(NSTimeInterval ) seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}


//////////////////////////////////////////////////////////////////
//--format date from date to string
+(NSString *) formatDateFromString8:(NSDate *) date //-- co lun
{
    //    NSLog(@"String date: %@", stringDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"];
   
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    ///NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    //NSDate *localDate = [date dateByAddingTimeInterval:timeZoneOffset];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+(NSString *) formatDateFromString4:(NSString *) formattedString //-- co lun
{
    //    NSLog(@"String date: %@", stringDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString: formattedString];
    if (date == nil)
    {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        date = [dateFormatter dateFromString: formattedString];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else{
       [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSDate *) formatDateFromString6:(NSString *) formattedString //-- co lun
{
    //    NSLog(@"String date: %@", stringDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString: formattedString];
    if (date == nil)
    {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        date = [dateFormatter dateFromString: formattedString];
   
    }
   

    return date;
}
+(NSString *) formatDateFromDate3:(NSDate *) date //-- co dung
{
    //NSLog(@"String date: %@", ts_utc);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    //NSTimeZone *tz = [NSTimeZone localTimeZone];
    //[dateFormatter setTimeZone:tz];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}


+(NSString *) formatDateFromDate9:(NSDate *) date //-- co dung
{
    //NSLog(@"String date: %@", ts_utc);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    //NSTimeZone *tz = [NSTimeZone localTimeZone];
    //[dateFormatter setTimeZone:tz];
    NSString *dateStr = [dateFormatter stringFromDate:date];

    return dateStr;
}


+(NSString *) formatDateFromDate7:(NSDate *) date //-- co dung
{
    //NSLog(@"String date: %@", ts_utc);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    /* cai nay ko duoc conver UTC and GMT */
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}






+(NSString*)HourCalculation:(NSString*)PostDate

{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy HH:mm"];

    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    NSDate *ExpDate = [dateFormat dateFromString:PostDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
   NSDateComponents *components = [calendar components:( NSCalendarUnitDay|NSCalendarUnitWeekOfMonth|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:ExpDate toDate:[NSDate date] options:0];
    NSString *time;
    if(components.year!=0)
    {
        if(components.year==1)
        {
            time=[NSString stringWithFormat:@"%ld year",(long)components.year];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld years",(long)components.year];
        }
    }
    else if(components.month!=0)
    {
        if(components.month==1)
        {
            time=[NSString stringWithFormat:@"%ld month",(long)components.month];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld months",(long)components.month];
        }
    }
    else if(components.weekOfMonth!=0)
    {
        if(components.weekOfMonth==1)
        {
            time=[NSString stringWithFormat:@"%ld week",(long)components.weekOfMonth];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld weeks",(long)components.weekOfMonth];
        }
    }
    else if(components.day!=0)
    {
        if(components.day==1)
        {
            time=[NSString stringWithFormat:@"%ld day",(long)components.day];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld days",(long)components.day];
        }
    }
    else if(components.hour!=0)
    {
        if(components.hour==1)
        {
            time=[NSString stringWithFormat:@"%ld hour",(long)components.hour];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld hours",(long)components.hour];
        }
    }
    else if(components.minute!=0)
    {
        if(components.minute==1)
        {
            time=[NSString stringWithFormat:@"%ld min",(long)components.minute];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld mins",(long)components.minute];
        }
    }
    else if(components.second>=0)
    {
        if(components.second==0)
        {
            time=[NSString stringWithFormat:@"1 sec"];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld secs",(long)components.second];
        }
    }
    return [NSString stringWithFormat:@"%@ ago",time];
}

+(NSString *) formatStringFromDate2:(NSString *) formattedString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];

    NSDate *date = [df dateFromString: formattedString];

    
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateStr = [df stringFromDate:date];
    NSLog(@"%@ - %@",formattedString, dateStr);
    return  dateStr;
}

+(NSString *) formatStringFromDate1:(NSString *) formattedString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd MMMM yyyy"];

    
    NSDate *date = [df dateFromString: formattedString];

    [df setDateFormat:@"dd MMMM yyyy HH:mm"];
    
    
    NSString *dateStr = [df stringFromDate:date];
    return  dateStr;
}


//////////////////////////////////////////////////////////////////
//--formatdate from string to date
+(NSString *) formatStringFromDate:(NSString *) formattedString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"HH:mm dd/MM/yyyy"];
    
    NSDate *date = [df dateFromString: formattedString];
    if (date.isToday)
    {
       [df setDateFormat:@"HH:mm"];
    }
    else{
        [df setDateFormat:@"dd/MM/yy"];
    }

    NSString *dateStr = [df stringFromDate:date];
    
    return dateStr;
}



//- (NSString  *)dateUS:(NSString *) dateStr
//{
//    // e.g. "Sun, 06 Nov 1994 08:49:37 GMT"
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	//[dateFormatter setDateFormat:@"%a, %d %b %Y %H:%M:%S GMT"]; // won't work with -init, which uses new (unicode) format behaviour.
//	[dateFormatter setDateFormat:@"MMM dd, HH:mm"];
//
//    NSDate *gmtDate  = [Common formatDateFromString:dateStr];
//    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:gmtDate];
//    NSDate *localDate = [gmtDate dateByAddingTimeInterval:timeZoneOffset];
//    
//    NSString *dateStr2 = [dateFormatter stringFromDate:localDate];
//
//    
//	return dateStr2;
//}

+ (NSString *) getViewCount:(NSInteger ) money
{
    
    NSInteger trillion = money / 1000000000;
    NSInteger million = (money % 1000000000)/1000000;
    NSInteger kMoney = (money%1000000)/1000;
    if (trillion > 0)
    {
        return [NSString stringWithFormat:@"%ldB",(long)trillion];
    }
    else if (million > 0)
    {
        return [NSString stringWithFormat:@"%ldM",(long)million];
    }
    return [NSString stringWithFormat:@"%ldK",(long)kMoney];
}


+ (NSString*)parseISO8601Time:(NSString*)duration
{
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    //Get Time part from ISO 8601 formatted duration http://en.wikipedia.org/wiki/ISO_8601#Durations
    duration = [duration substringFromIndex:[duration rangeOfString:@"T"].location];
    
    while ([duration length] > 1) { //only one letter remains after parsing
        duration = [duration substringFromIndex:1];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:duration];
        
        NSString *durationPart = [[NSString alloc] init];
        [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] intoString:&durationPart];
        
        NSRange rangeOfDurationPart = [duration rangeOfString:durationPart];
        
        duration = [duration substringFromIndex:rangeOfDurationPart.location + rangeOfDurationPart.length];
        
        if ([[duration substringToIndex:1] isEqualToString:@"H"]) {
            hours = [durationPart intValue];
        }
        if ([[duration substringToIndex:1] isEqualToString:@"M"]) {
            minutes = [durationPart intValue];
        }
        if ([[duration substringToIndex:1] isEqualToString:@"S"]) {
            seconds = [durationPart intValue];
        }
    }
    
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}


//-------------------------------------------------------
//
+(NSString *) returnFileNameWithoutTheExtension:(NSString *)fileName
{
    NSString *fileName_extension = [fileName pathExtension];
    NSInteger fileNameExtensionLength = [fileName_extension length];
    NSInteger fileName_length = [fileName length];
    fileName_length = fileName_length - (1 + fileNameExtensionLength);
    return [ fileName substringWithRange:NSMakeRange(0, fileName_length) ];
}



//-------------------------------------------------------
//
+(NSString *)returnMusicTimeFormatWithValue: (float)value
{
    if (value < 0) {
        value = 0.0f;
    }
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:value];
    //Then specify output format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"m:ss"];
    
    NSString *timeLeft = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:d]];
    
    return timeLeft;
    
}



+ (UIImage *) imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, 1, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithColor1:(UIColor *)color andSize:(CGSize) size{
    static UIImage *blueCircle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
        CGContextFillEllipseInRect(ctx, rect);
        
        CGContextRestoreGState(ctx);
        blueCircle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return blueCircle;
}


+(UIImage *) imageWithColor2:(UIColor *)color andSize:(CGSize) size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, 1, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

}


+ (void) makeCornerTopOrBotton:(UIButton *) button andTop:(BOOL) isTop
{
    UIBezierPath *maskPath =  nil;
    if (isTop)
    {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake((IS_IPAD?7:4), (IS_IPAD?7:4))];
    }
    else{
        maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake((IS_IPAD?7:4), (IS_IPAD?7:4))];
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path  = maskPath.CGPath;
    button.layer.mask = maskLayer;
    
}


+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexString hasPrefix:@"#"])
        hexString = [hexString substringFromIndex:1];
    else if([hexString hasPrefix:@"0x"])
        hexString = [hexString substringFromIndex:2];
    
    NSInteger l = [hexString length];
    if ((l!=3) && (l!=4) && (l!=6) && (l!=8))
        return nil;
    
    if ([hexString length] > 2 && [hexString length]< 5) {
        NSMutableString *newHexString = [[NSMutableString alloc] initWithCapacity:[hexString length]*2];
        [hexString enumerateSubstringsInRange:NSMakeRange(0, [hexString length])
                                      options:NSStringEnumerationByComposedCharacterSequences
                                   usingBlock:^(NSString *substring,
                                                NSRange substringRange,
                                                NSRange enclosingRange,
                                                BOOL *stop)
         {
             [newHexString appendFormat:@"%@%@", substring, substring];
         }];
        hexString = newHexString;
    }
    
    if ([hexString length] == 6)
        hexString = [hexString stringByAppendingString:@"ff"];
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum])
        return nil;
    return [self _colorFromHex:hexNum];
}


+ (UIColor *)_colorFromHex:(NSUInteger)hexInt
{
    int r,g,b,a;
    
    r = (hexInt >> 030) & 0xFF;
    g = (hexInt >> 020) & 0xFF;
    b = (hexInt >> 010) & 0xFF;
    a = hexInt & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

+ (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd
{
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border.frame = CGRectMake(0, 0, viewAdd.frame.size.width, borderWidth);
    [viewAdd addSubview:border];
}

+ (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, viewAdd.frame.size.height - borderWidth, viewAdd.frame.size.width, borderWidth);
    [viewAdd addSubview:border];
}

+ (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    border.frame = CGRectMake(0, 0, borderWidth, viewAdd.frame.size.height);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [viewAdd addSubview:border];
}

+ (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andView:(UIView *) viewAdd {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border.frame = CGRectMake(viewAdd.frame.size.width - borderWidth, 0, borderWidth, viewAdd.frame.size.height);
    [viewAdd addSubview:border];
}

+(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    position.y = position.y - view.height;
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

+(UIImage *)makeRoundedImage:(UIColor *) color sizeObject:(CGSize) sizeObject radius: (float) radius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, sizeObject.width, sizeObject.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
   
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+(BOOL)checkIfDirectoryAlreadyExists:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL fileExists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    return fileExists;
    
}

+ (NSString *)appSupportDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if (paths && [paths count] > 0)
        return [paths objectAtIndex:0];
    return nil;
}

+ (NSString *)documentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}



+ (void)initDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // create appdir
    NSString *cacheDir = [self cacheDir];
    if (![fm fileExistsAtPath:cacheDir]) {
        [fm createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        // Skip backup
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:cacheDir]];
    }
    
    NSString *tmpDir = [self tempDir];
    if (![fm fileExistsAtPath:tmpDir]) {
        [fm createDirectoryAtPath:tmpDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *thumbDir = [self thumbDir];
    if (![fm fileExistsAtPath:thumbDir]) {
        [fm createDirectoryAtPath:thumbDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *rootDir = [self cacheRootDir];
    if (![fm fileExistsAtPath:rootDir]) {
        [fm createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *downloadDir = [self downloadDir];
    if (![fm fileExistsAtPath:downloadDir]) {
        [fm createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString *)cacheDir {
    return [[self appSupportDir] stringByAppendingPathComponent:@"home"];
}


+ (NSString *)tempDir {
    return [[self cacheDir] stringByAppendingPathComponent:@"tmp"];
}


+ (NSString *)cacheRootDir {
    return [[self cacheDir] stringByAppendingPathComponent:@"root"];
}


+ (NSString *)thumbDir {
    return [[self cacheDir] stringByAppendingPathComponent:@"img"];
}


+ (NSString *)rootDir {
    return [self documentDir];
}


+ (NSString *)mediaRootDir {
    return [self rootDir];
}


+ (NSString *)inboxDir {
    return [[self rootDir] stringByAppendingPathComponent:@"Inbox"];
}


+ (NSString *)downloadDir {
    return [[self cacheDir] stringByAppendingPathComponent:@"Downloads"];
}



//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
#pragma mark - GROUP MODEL


+ (NSString*) dbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    return path;
}


+ (void) globalResignFirstResponder {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    for (UIView * view in [window subviews]){
        [self globalResignFirstResponderRec:view];
    }
}

+ (void) globalResignFirstResponderRec:(UIView*) view {
    if ([view respondsToSelector:@selector(resignFirstResponder)]){
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]){
        [self globalResignFirstResponderRec:subview];
    }
}

+ (BOOL)soundOn
{
    id obj = [[NSUserDefaults standardUserDefaults] valueForKey:@"SoundOn"];
    return (obj != nil)? [obj boolValue] : YES;
}

+ (void)setSound:(BOOL)bl
{
    [[NSUserDefaults standardUserDefaults] setBool:bl forKey:@"SoundOn"];
}


+ (BOOL)getSound
{
    id obj = [[NSUserDefaults standardUserDefaults] valueForKey:@"SoundOn"];
    return (obj != nil)? [obj boolValue] : YES;
    //return [[NSUserDefaults standardUserDefaults] boolForKey:@"SoundOn"];
}




+(void) showAlert:(NSString *) title andMessage:(NSString *) message andtitleButton:(NSString *) tittleButton{
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:tittleButton otherButtonTitles: nil];
    
    [alert show];
}

@end
