//
//  UINavigationController+KPAKit.m
//  KPAKitProject
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "UINavigationController+KPAKit.h"

@implementation UINavigationController (KPAKit)

- (BOOL)kpa_popToFirstViewControllerOfClass:(Class)cl animated:(BOOL)animated {
    for (UIViewController *viewController in [self viewControllers]) {
        if ([viewController isKindOfClass:cl]) {
            [self popToViewController:viewController animated:animated];
            return YES;
        }
    }
    return NO;
}


@end
