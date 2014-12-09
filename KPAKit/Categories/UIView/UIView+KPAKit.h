//
//  UIView+KPAKit.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 5/19/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPAKitDefinitions.h"

@interface UIView (KPAKit)

/**
 * @param size The size to change the view's bound's size too.
 * @discussion This method will change the view's bound's size too.
 */
- (void)kpa_modifyBoundsSize:(CGSize)size;

/**
 * @param bounds The bounds the resize will be in relation to.
 * @param percentage The percentage of the bounds to size this view's bounds as.
 * @discussion This will resize the view's bounds in relation to the passed bounds.
 */
- (void)kpa_resizeBoundsInRelationToBounds:(CGRect)bounds withPercentage:(KPA2dValue)percentage;

/** @discussion This will call kpa_resizeBoundsInRelationToBounds:: with the bounds of the passed in view's bounds */
- (void)kpa_resizeBoundsInRelationToView:(UIView *)view withPercentage:(KPA2dValue)percentage;

/**
 *
 * @discussion This method is used to position a view in another based relatively on the bounds passed in. Basically the center as a percentage of the paramater bounds.
 * @param bounds This is the bounds that this view will be positioned relative too.
 * @param percentage This is a 2d value but should be between 0 and 1. Simply, it will multiply the values of the param bounds to get a center for this view. So {0.5, 0.5} will be the center of the paramater bounds.
 * @param doesAllowEscapingViewBounds This determines whether or not this view can escape the bounds passed in.
 */
- (void)kpa_positionViewInBounds:(CGRect)bounds withPercentage:(KPA2dValue)percentage doesAllowEscapingViewBounds:(BOOL)doesAllowEscapingViewBounds;

/** @discussion This will call kpa_positionViewInBounds::: with the bounds of the passed in view's bounds */

- (void)kpa_positionViewInView:(UIView *)view withPercentage:(KPA2dValue)percentage doesAllowEscapingViewBounds:(BOOL)doesAllowEscapingViewBounds;

/**
 * @discussion This calls kpa_positionViewInView:withPercentagePoint: with self.superView as the view param.
 */
- (void)kpa_positionViewWithPercentage:(KPA2dValue)percentage doesAllowEscapingViewBounds:(BOOL)doesAllowEscapingViewBounds;

/**
 * @discussion This moves the center of this view by a given point.
 * @param p The vector to move the view by.
 */
- (void)kpa_moveByAmount:(CGPoint)p;

/**
 * @discussion This calls kpa_repositionToKeepInBounds: with the paramater view's bounds.
 */
- (void)kpa_repositionToKeepInView:(UIView *)view;

/**
 * @discussion This will resposition this view to keep all of it inside the paramater bounds.
 * @param bounds This is the bounds to keep this view inside.
 */
- (void)kpa_repositionToKeepInBounds:(CGRect)bounds;

/**
 *
 * @param offset The offset to set the position of in relation to the view passed in.
 * @param view The view to offset with the offset passed in.
 */
- (void)kpa_placeViewOffset:(CGPoint)offset ofView:(UIView *)view;

/**
 * @return This method will return the size of the view's bound.
 */
- (CGSize)kpa_boundsSize;

- (void)kpa_placeViewBetweenView:(UIView *)v1 andView:(UIView *)v2;

@end
