//
//  UIBarButtonItemCustom.m
//  Download
//
//  Created by Vuong Nguyen on 9/11/14.
//  Copyright (c) 2014 IdeasHouse. All rights reserved.
//

#import "UIBarButtonItemCustom.h"

@implementation UIBarButtonItemCustom

- (UIBarButtonItemCustom *)initWithCustomUIButton:(UIButton *)customButton
{
    self = [self initWithCustomView:customButton];
    if (self) {
  
        [self initializer];
        
    }
    
    return self;
}

- (void)initializer
{
  
}

@end
