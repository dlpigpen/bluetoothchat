//
//  UIView+Frame.m
//
//  Created by sho yakushiji on 2013/05/15.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "UIBarButtonItem + WithImageOnly.h"

@implementation UIBarButtonItem (WithImageOnly)

- (id)initWithImageOnly:(UIImage *)image target:(id)target action:(SEL)action andIsRight:(BOOL ) isRight
{
    
    CGRect frame = CGRectZero;
    if (isRight)
    {
          frame = CGRectMake(5, 0, 60, 44);;
    }
    else{
           frame = CGRectMake(2, 0, 60, 44);;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (isRight)
    {
         [button setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    }
    else{
         [button setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    }
    //[button setBackgroundColor:[UIColor redColor]];
  
    UIView *viewButton = [[UIView alloc] initWithFrame:FRAME(0, 0, 60, 40)];
    [viewButton addSubview:button];
    [viewButton setBackgroundColor:[UIColor clearColor]];
    
    return [self initWithCustomView:viewButton];
}




@end
