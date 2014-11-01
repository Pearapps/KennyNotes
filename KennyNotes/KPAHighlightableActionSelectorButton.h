//
//  KPAHighlightableActionSelectorButton.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/12/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPAHighlightableActionSelectorButton : UIButton

@property (nonatomic, readonly) UIColor *currentColorToDrawWith;

@property (nonatomic, copy) NSString *kpa_buttonTitle;

@end
