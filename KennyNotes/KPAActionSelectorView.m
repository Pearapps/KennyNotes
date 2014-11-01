//
//  KPAActionSelectorView.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/11/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAActionSelectorView.h"
#import "KPAThemeController.h"
#import "KPAMailEnvelopeButton.h"

@interface KPAActionSelectorView ()

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation KPAActionSelectorView

- (instancetype)initWithFrame:(CGRect)frame andSelectionTypes:(KPAActionSheetSelectionType)selectionTypes {
    self = [super initWithFrame:frame];
    if (self) {
        
        __weak KPAActionSelectorView *weakSelf = self;
        
        [self setBoundsChangeBlock:^(CGRect new){ [weakSelf organizeViews]; }];
        
        self.buttons = [NSMutableArray new];
        
        [self setBackgroundColor:[[KPAThemeController controller] currentCellColor]];
        
        if (selectionTypes & KPAActionSheetSelectionTypeMail) {
            KPAMailEnvelopeButton *envelopeView = [[KPAMailEnvelopeButton alloc] initWithFrame:CGRectMake(0, 0, 52, 48)];
            [self addSubview:envelopeView];
            envelopeView.kpa_buttonTitle = @"Mail";
            [envelopeView addTarget:self action:@selector(enveloper:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:envelopeView];
        }
        
        [self organizeViews];
        
    }
    return self;
}

- (void)organizeViews {
    
    NSInteger count = 0;
    
    for (UIButton *button in self.buttons) {
        count++;
        [button setCenter:CGPointMake(count*(CGRectGetWidth(button.bounds)/2 + 20), CGRectGetHeight(self.bounds)/2+3)];
        
    }
}

- (void)enveloper:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelect:)]) {
        [self.delegate didSelect:KPAActionSheetSelectionTypeMail];
    }
}

@end
