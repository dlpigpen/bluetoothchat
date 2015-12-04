//
//  UIImageView+Render.m
//  UIKitCategoryAdditions
//

#import "UIImageView+Render.h"



@implementation UIImageView (Render)

-(void)renderColorImageWithNameImage:(NSString *) nameImage AndColor:(UIColor *) color
{
    UIImage *image = [UIImage imageNamed:nameImage];
    self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:color];
}


@end