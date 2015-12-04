//
//  FileManager.m
//  WordPuzzle
//
//  Created by Duc Nguyen on 11/14/14.
//  Copyright (c) 2014 Balls Addicting. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager



- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
#ifdef DEBUG
    NSLog(@"URL: %@", URL);
    
#endif
    
    
    //--assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
    
}


-(NSString *)sqlitePath:(NSString *)nameDatabase
{

    NSString *cacheRootDir = [Common cacheDir];
    NSString* foofile = [cacheRootDir stringByAppendingPathComponent:kNameDataBase];
    return foofile;
}


@end
