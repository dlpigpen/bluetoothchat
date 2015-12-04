//
//  UIView+Frame.h
//
//  Created by sho yakushiji on 2013/05/15.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WithImageOnly)
- (id)initWithImageOnly:(UIImage *)image target:(id)target action:(SEL)action andIsRight:(BOOL ) isRight;

@end