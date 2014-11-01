//
//  KPAThemeController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/27/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAThemeController.h"
#import "KPAKit.h"

@interface KPAThemeController ()

@property (nonatomic, assign) KPATheme currentTheme;

@end

@implementation KPAThemeController

+ (KPAThemeController *)controller {
    KPACreateSingleton(^{
        return [self new];
    });
}

- (instancetype)init {
    self = [super init];
    
    if (!self) { return nil; }
    
    self.currentTheme = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KPATheme"] integerValue];

    return self;
}

- (void)didSelectTheme:(KPATheme)theme {
    self.currentTheme = theme;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KPADidSetThemeNotificationName object:@(theme) userInfo:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.currentTheme) forKey:@"KPATheme"];
}

- (UIColor *)backgroundColorForTheme:(KPATheme)theme {
    if (theme == KPAThemeDark) {
        return [UIColor blackColor];
    }
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (UIKeyboardAppearance)keyboardAppearanceForTheme:(KPATheme)theme {
    if (theme == KPAThemeDark) {
        return UIKeyboardAppearanceDark;
    }
    return UIKeyboardAppearanceDefault;
}

- (UIColor *)cellColorForTheme:(KPATheme)theme {
    if (theme == KPAThemeDark) {
        return [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    return [UIColor whiteColor];
}

- (UIColor *)cellTextColorForTheme:(KPATheme)theme {
    if (theme == KPAThemeDark) {
        return [UIColor whiteColor];
    }
    return [UIColor blackColor];
}

- (UIColor *)cellSelectionColorForTheme:(KPATheme)theme {
    if (theme == KPAThemeDark) {
        return [UIColor colorWithWhite:0.15 alpha:1.0];
    }
    return [UIColor colorWithWhite:0.8 alpha:1.0];
}

- (UIBarStyle)barStyleForTheme:(KPATheme)theme {
    if (theme == KPAThemeDark) {
        return UIBarStyleBlack;
    }
    return UIBarStyleDefault;
}

- (UIKeyboardAppearance)currentKeyboardAppearance {
    return [self keyboardAppearanceForTheme:self.currentTheme];
}

- (UIColor *)currentCellTextColor {
    return [self cellTextColorForTheme:self.currentTheme];
}

- (UIColor *)currentBackgroundColor {
    return [self backgroundColorForTheme:self.currentTheme];
}

- (UIColor *)currentCellSelectionColor {
    return [self cellSelectionColorForTheme:self.currentTheme];
}

- (UIColor *)currentCellColor {
    return [self cellColorForTheme:self.currentTheme];
}

- (UIBarStyle)currentBarStyle {
    return [self barStyleForTheme:self.currentTheme];
}

- (void)themeViewController:(UIViewController *)viewController {
    viewController.view.backgroundColor = [self backgroundColorForTheme:self.currentTheme];
    [[[viewController navigationController] navigationBar] setBarStyle:[self barStyleForTheme:self.currentTheme]];
}

@end
