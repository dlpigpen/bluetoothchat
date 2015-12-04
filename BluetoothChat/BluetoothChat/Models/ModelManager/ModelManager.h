//
//  ModelManager.h
//  WordPuzzle
//
//  Created by Duc Nguyen on 11/14/14.
//  Copyright (c) 2014 Balls Addicting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNameDataBase @"Database.sqlite"

typedef void (^CallBackCompletion)(BOOL isCopied);


@interface ModelManager : NSObject
@property (nonatomic, strong) FMDatabaseQueue *queueDB;
@property (nonatomic, copy) CallBackCompletion completionBlock;
@property (nonatomic, strong) NSString *nameTable;


//- (id) initWithBlock:(CallBackCompletion) block;
//+ (instancetype) modelManager:(CallBackCompletion) block;

+ (ModelManager*)allocInstance;
@end
