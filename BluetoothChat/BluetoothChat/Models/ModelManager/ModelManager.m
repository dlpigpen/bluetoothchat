//
//  ModelManager.m
//  WordPuzzle
//
//  Created by Duc Nguyen on 11/14/14.
//  Copyright (c) 2014 Balls Addicting. All rights reserved.
//

#import "ModelManager.h"
#include <sys/xattr.h>
#import "FileManager.h"



@interface ModelManager()

@end


@implementation ModelManager


#pragma mark -  Initial Model Manager


//+ (instancetype) modelManager:(CallBackCompletion) block
//{
//    static ModelManager *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] initWithBlock:block];
//        
//    });
//    return sharedMyManager;
//}
//
//
//-(void) copyData
//{
//    
//}
//
//
//- (id) initWithBlock:(CallBackCompletion) block
//{
//    if (self = [super init])
//    {
//        self.completionBlock =  block;
//        
//        [self checkAndCopyFileDatabase];
//    }
//    
//    return self;
//}
static ModelManager *instance = nil;
+ (ModelManager*)allocInstance
{
    if (instance == nil)
    {
        instance = [[ModelManager alloc] init];

        [instance checkAndCopyFileDatabase];
    }
    return instance;
}


#pragma mark - Copy File database to NSDocument


-(void) checkAndCopyFileDatabase
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheRootDir = [Common cacheDir];
   
    //--check file existed
    NSString* foofile = [cacheRootDir stringByAppendingPathComponent:kNameDataBase];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    NSLog(@"File path %@",foofile);
    if (fileExists == YES)
    {
        //--open database
        [self openDatabase];
        
        [self performSelector:@selector(callBackView:) withObject:[NSNumber numberWithBool:YES]];
        
        return;
    }
    
    //--
    dispatch_queue_t _queue = dispatch_queue_create("com.ideahouse.wordbrain", NULL);
    
    dispatch_sync(_queue, ^() {
        
        
        NSError *error;
        //--copy
        NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath]
                                          stringByAppendingPathComponent:kNameDataBase];
        [fileManager copyItemAtPath:resourceDBFolderPath toPath:foofile error:&error];
        
        //--set flag
        if (error == nil)
        {
            FileManager *fileManage = [[FileManager alloc] init];
            [fileManage addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:foofile]];
            
            //--call back view
            [self performSelector:@selector(callBackView:) withObject:[NSNumber numberWithBool:YES]];
            
            //--open database
            [self openDatabase];
            
        }else{
            if (_completionBlock != NULL)
                [self performSelector:@selector(callBackView:) withObject:[NSNumber numberWithBool:NO]];
        }
        
    }); // end critical section!  All further queries using this queue will us
}


-(void) callBackView:(NSNumber *) number
{
    BOOL valueCallBack  = [number boolValue];
    
    if (_completionBlock != NULL){
        self.completionBlock(valueCallBack);
    }
}


-(void) openDatabase
{
    //--file database
     FileManager *fileManage = [[FileManager alloc] init];
    NSString* foofile = [fileManage sqlitePath:kNameDataBase];
    
    if (_queueDB == nil)
    {
        self.queueDB =  [FMDatabaseQueue databaseQueueWithPath:foofile];
        
    }
}

#pragma mark - Utilities

- (NSString *) getFields:(NSArray *) fields
{
    if (fields == nil)
    {
        NSAssert(fields != nil, @"Required object fields is not nil");
    }
    
    if (fields.count <= 0)
    {
        return @"";
    }
    
    __block NSMutableString *data = [NSMutableString string];
    
    [fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if (idx == 0)
           [data appendString:obj];
     else
         [data appendFormat:@"%@%@",@",", obj];
    }];
    
    return data;
}

- (NSString *) getConditions:(NSDictionary *) conditions
{
    if (conditions == nil)
    {
        NSAssert(conditions != nil, @"Required object conditions is not nil");
    }

    __block NSMutableString *data = [NSMutableString string];
    __block NSInteger idx = 0;
    [conditions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (idx == 0)
            [data appendString:key];
        else
            [data appendFormat:@"%@%@%@",@",", key, @"=?"];
        
        idx++;
    }];
    
    return data;
}



- (void)dealloc {

    
}

@end
