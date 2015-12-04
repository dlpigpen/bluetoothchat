//
//  FileManager.h
//  WordPuzzle
//
//  Created by Duc Nguyen on 11/14/14.
//  Copyright (c) 2014 Balls Addicting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
- (NSString *)sqlitePath:(NSString *) nameDatabase;


@end
