//
//  UIView+KPAKit.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 5/19/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "UIView+KPAKit.h"
#import "KPAKit.h"

@implementation UIView (KPAKit)

- (void)kpa_resizeBoundsInRelationToView:(UIView *)view withPercentage:(KPA2dValue)percentage {
    [self kpa_resizeBoundsInRelationToBounds:view.bounds withPercentage:percentage];
}

- (void)kpa_resizeBoundsInRelationToBounds:(CGRect)bounds withPercentage:(KPA2dValue)percentage {
    [self kpa_modifyBoundsSize:CGSizeMake(CGRectGetWidth(bounds) * percentage.x, CGRectGetHeight(bounds) * percentage.y)];
}

- (void)kpa_positionViewWithPercentage:(KPA2dValue)percentage doesAllowEscapingViewBounds:(BOOL)doesAllowEscapingViewBounds {
    [self kpa_positionViewInView:self.superview withPercentage:percentage doesAllowEscapingViewBounds:doesAllowEscapingViewBounds];
}

- (void)kpa_positionViewInView:(UIView *)view withPercentage:(KPA2dValue)percentage doesAllowEscapingViewBounds:(BOOL)doesAllowEscapingViewBounds {
    [self kpa_positionViewInBounds:view.bounds withPercentage:percentage doesAllowEscapingViewBounds:doesAllowEscapingViewBounds];
}

- (void)kpa_positionViewInBounds:(CGRect)bounds withPercentage:(KPA2dValue)percentage doesAllowEscapingViewBounds:(BOOL)doesAllowEscapingViewBounds {
    [self setCenter:CGPointMake(CGRectGetWidth(bounds) * percentage.x, CGRectGetHeight(bounds) * percentage.y)];
    
    if (!doesAllowEscapingViewBounds) {
        [self kpa_repositionToKeepInBounds:bounds];
    }
}

- (void)kpa_moveByAmount:(CGPoint)p {
    [self setCenter:CGPointMake(self.center.x + p.x, self.center.y + p.y)];
}

- (void)kpa_modifyBoundsSize:(CGSize)size {
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, size.width, size.height);
}

- (void)kpa_repositionToKeepInView:(UIView *)view {
    [self kpa_repositionToKeepInBounds:view.bounds];
}

- (void)kpa_repositionToKeepInBounds:(CGRect)bounds {
    if (self.center.x - CGRectGetWidth(self.bounds)/2.f < bounds.origin.x) {
        self.center = CGPointMake(CGRectGetWidth(self.bounds)/2.f, self.center.y);
    } if (self.center.y - CGRectGetHeight(self.bounds)/2.f < bounds.origin.y) {
        self.center = CGPointMake(self.center.x, CGRectGetHeight(self.bounds)/2.f);
    }
    
    if (self.center.x + CGRectGetWidth(self.bounds)/2.f > CGRectGetMaxX(bounds)) {
        self.center = CGPointMake(CGRectGetMaxX(bounds) - CGRectGetWidth(self.bounds)/2.f, self.center.y);
    } if (self.center.y + CGRectGetHeight(self.bounds)/2.f > CGRectGetMaxY(bounds)) {
        self.center = CGPointMake(self.center.x,  CGRectGetMaxY(bounds) - CGRectGetHeight(self.bounds)/2);
    }
}

- (void)kpa_placeViewOffset:(CGPoint)offset ofView:(UIView *)view {
    self.center = CGPointMake(view.center.x + offset.x, view.center.y + offset.y);
}

- (void)kpa_placeViewBetweenView:(UIView *)v1 andView:(UIView *)v2 {
    self.center = kpa_midpoint(v1.center, v2.center);
}

- (CGSize)kpa_boundsSize {
    return self.bounds.size;
}

@end
