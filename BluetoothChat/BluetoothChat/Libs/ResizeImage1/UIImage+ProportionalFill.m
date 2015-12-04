//
//  UIImage+ProportionalFill.m
//
//  Created by Matt Gemmell on 20/08/2008.
//  Copyright 2008 Instinctive Code.
//

#import "UIImage+ProportionalFill.h"


@implementation UIImage (MGProportionalFill)


- (UIImage *)imageToFitSize:(CGSize)fitSize method:(MGImageResizingMethod)resizeMethod
{
	float imageScaleFactor = 1.0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([self respondsToSelector:@selector(scale)]) {
		imageScaleFactor = [self scale];
	}
#endif
	
    float sourceWidth = [self size].width * imageScaleFactor;
    float sourceHeight = [self size].height * imageScaleFactor;
    float targetWidth = fitSize.width;
    float targetHeight = fitSize.height;
    BOOL cropping = !(resizeMethod == MGImageResizeScale);
	
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    CGRect sourceRect, destRect;
    if (cropping) {
        destRect = CGRectMake(0, 0, targetWidth, targetHeight);
        float destX = -1, destY = -1;
        if (resizeMethod == MGImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == MGImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
				// Crop top
				destX = 0.0;
				destY = 0.0;
            } else {
				// Crop left
                destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == MGImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
				// Crop bottom
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
            } else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
        destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
    }
    
    // Create appropriately modified image.
	UIImage *image = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 0.0); // 0.0 for scale means "correct scale for device's main screen".
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
		image = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:self.imageOrientation]; // create cropped UIImage.
		[image drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
		CGImageRelease(sourceImg);
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
#endif
	if (!image) {
		// Try older method.
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, fitSize.width, fitSize.height, 8, (fitSize.width * 4),
													 colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect);
		CGContextDrawImage(context, destRect, sourceImg);
		CGImageRelease(sourceImg);
		CGImageRef finalImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		image = [UIImage imageWithCGImage:finalImage];
		CGImageRelease(finalImage);
	}
	
    return image;
}


- (UIImage *)imageCroppedToFitSize:(CGSize)fitSize
{
    return [self imageToFitSize:fitSize method:MGImageResizeCrop];
}


- (UIImage *)imageScaledToFitSize:(CGSize)fitSize
{
    return [self imageToFitSize:fitSize method:MGImageResizeScale];
}





// width	Width given, height automagically selected to preserve aspect ratio.
// xheight	Height given, width automagically selected to preserve aspect ratio.
// widthxheight	Maximum values of height and width given, aspect ratio preserved.
// widthxheight^	Minimum values of width and height given, aspect ratio preserved.
// widthxheight!	Exact dimensions, no aspect ratio preserved.
// widthxheight#	Crop to this exact dimensions.

- (UIImage *) resizedImageByMagick: (NSString *) spec
{
    
    if([spec hasSuffix:@"!"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        NSUInteger width = [[widthAndHeight objectAtIndex: 0] integerValue];
        NSUInteger height = [[widthAndHeight objectAtIndex: 1] integerValue];
        UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
        return [newImage drawImageInBounds: CGRectMake (0, 0, width, height)];
    }
    
    if([spec hasSuffix:@"#"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        NSUInteger width = [[widthAndHeight objectAtIndex: 0] integerValue];
        NSUInteger height = [[widthAndHeight objectAtIndex: 1] integerValue];
        UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
        return [newImage croppedImageWithRect: CGRectMake ((newImage.size.width - width) / 2, (newImage.size.height - height) / 2, width, height)];
    }
    
    if([spec hasSuffix:@"^"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        return [self resizedImageWithMinimumSize: CGSizeMake ([[widthAndHeight objectAtIndex: 0] longLongValue],
                                                              [[widthAndHeight objectAtIndex: 1] longLongValue])];
    }
    
    NSArray *widthAndHeight = [spec componentsSeparatedByString: @"x"];
    if ([widthAndHeight count] == 1) {
        return [self resizedImageByWidth: [spec integerValue]];
    }
    if ([[widthAndHeight objectAtIndex: 0] isEqualToString: @""]) {
        return [self resizedImageByHeight: [[widthAndHeight objectAtIndex: 1] integerValue]];
    }
    return [self resizedImageWithMaximumSize: CGSizeMake ([[widthAndHeight objectAtIndex: 0] longLongValue],
                                                          [[widthAndHeight objectAtIndex: 1] longLongValue])];
}

- (CGImageRef) CGImageWithCorrectOrientation
{
    if (self.imageOrientation == UIImageOrientationDown) {
        //retaining because caller expects to own the reference
        CGImageRetain([self CGImage]);
        return [self CGImage];
    }
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 180 * M_PI/180);
    }
    
    [self drawAtPoint:CGPointMake(0, 0)];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    return cgImage;
}


- (UIImage *) resizedImageByWidth:  (NSUInteger) width
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = width/original_width;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, width, round(original_height * ratio))];
}

- (UIImage *) resizedImageByHeight:  (NSUInteger) height
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = height/original_height;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * ratio), height)];
}

- (UIImage *) resizedImageWithMinimumSize: (CGSize) size
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio > height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

- (UIImage *) resizedImageWithMaximumSize: (CGSize) size
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio < height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

- (UIImage *) drawImageInBounds: (CGRect) bounds
{
    UIGraphicsBeginImageContext(bounds.size);
    [self drawInRect: bounds];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage*) croppedImageWithRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return subImage;
}


- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*)makeRoundCornersWithRadius:(const CGFloat)RADIUS {
    UIImage *image = self;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:RADIUS] addClip];
    // Draw your image
    [image drawInRect:RECT];
    
    // Get the image, here setting the UIImageView image
    //imageView.image
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageNew;
}

@end
