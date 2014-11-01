//
//  KPAThemeController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/27/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KPATheme)  {
    KPAThemeLight,
    KPAThemeDark
};

#define KPADidSetThemeNotificationName @"KPADidSetTheme"

@interface KPAThemeController : NSObject // TODO: rename or redefine class

+ (KPAThemeController *)controller;

- (void)didSelectTheme:(KPATheme)theme;

- (UIColor *)currentBackgroundColor;
- (UIColor *)currentCellColor;
- (UIColor *)currentCellTextColor;
- (UIColor *)currentCellSelectionColor;

- (UIKeyboardAppearance)currentKeyboardAppearance;
- (UIBarStyle)currentBarStyle;

@property (nonatomic, readonly) KPATheme currentTheme;

- (void)themeViewController:(UIViewController *)viewController;

@end
