//
//  KPAViewController.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 5/19/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KPAKit.h"
#import "KPAView.h"

/** 
 This is just a view controller that overrides load view and sets it to a KPAView. 
 Would strongly not recommend overloading loadView yourself and if you do just subclass UIViewController.
 */

@interface KPAViewController : UIViewController

/**
 * 
 * @return Just self.view casted to KPAView.
 */
- (KPAView *)kpa_view;

@end
