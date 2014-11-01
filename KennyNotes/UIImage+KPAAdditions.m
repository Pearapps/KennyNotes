//
//  UIImage+KPAAdditions.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/16/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "UIImage+KPAAdditions.h"

@implementation UIImage (KPAAdditions)

// http://stackoverflow.com/questions/6141298/how-to-scale-down-a-uiimage-and-make-it-crispy-sharp-at-the-same-time-instead
- (UIImage *)kpa_resizeImageProportionallyIntoNewSize:(CGSize)newSize {
    CGFloat scaleWidth = 1.0f;
    CGFloat scaleHeight = 1.0f;
    
    if (CGSizeEqualToSize(self.size, newSize) == NO) {
        
        //calculate "the longer side"
        if(self.size.width > self.size.height) {
            scaleWidth = self.size.width / self.size.height;
        } else {
            scaleHeight = self.size.height / self.size.width;
        }
    }
    
    //prepare source and target image
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    // Now we create a context in newSize and draw the image out of the bounds of the context to get
    // A proportionally scaled image by cutting of the image overlay
    UIGraphicsBeginImageContext(newSize);
    
    //Center image point so that on each egde is a little cutoff
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = newSize.width * scaleWidth;
    thumbnailRect.size.height = newSize.height * scaleHeight;
    thumbnailRect.origin.x = (int) (newSize.width - thumbnailRect.size.width) * 0.5;
    thumbnailRect.origin.y = (int) (newSize.height - thumbnailRect.size.height) * 0.5;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

//http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
