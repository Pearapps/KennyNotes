//
//  KPABorderedButton.h
//  KPAKitProject
//
//  Created by Kenneth Parker Ackerson on 6/23/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPABorderedButton : UIButton

+ (instancetype)borderedButtonWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andBorderRadius:(CGFloat)radius;

@property (nonatomic, assign) BOOL highlightOnSelection;

@end