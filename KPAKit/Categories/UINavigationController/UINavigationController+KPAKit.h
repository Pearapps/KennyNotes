//
//  UINavigationController+KPAKit.h
//  KPAKitProject
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (KPAKit)

- (BOOL)kpa_popToFirstViewControllerOfClass:(Class)cl animated:(BOOL)animated;

@end
