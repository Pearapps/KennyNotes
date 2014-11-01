//
//  UIImage+KPAAdditions.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/16/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KPAAdditions)

- (UIImage *)kpa_resizeImageProportionallyIntoNewSize:(CGSize)newSize;
- (UIImage *)normalizedImage;

@end
