//
//  KPABorderedButton.m
//  KPAKitProject
//
//  Created by Kenneth Parker Ackerson on 6/23/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPABorderedButton.h"
#import "KPAKit.h"

@interface KPABorderedButton ()

@property (nonatomic, strong) UIView *highlightView;

@end

@implementation KPABorderedButton

+ (instancetype)borderedButtonWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andBorderRadius:(CGFloat)radius {
    KPABorderedButton *button = [[self alloc] init];
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    button.layer.cornerRadius = radius;
    button.layer.masksToBounds = YES;
    return button;
}

- (void)setHighlightOnSelection:(BOOL)highlightOnSelection {
    
    if (_highlightOnSelection == highlightOnSelection) { return; }
    
    _highlightOnSelection = highlightOnSelection;
    
    if (_highlightOnSelection) {
        [self addTarget:self action:@selector(highlight) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(unhighlight) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    } else {
        [self removeTarget:self action:@selector(highlight) forControlEvents:UIControlEventTouchDown];
        [self removeTarget:self action:@selector(unhighlight) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    }
}

- (void)highlight {
    if (self.highlightView) { return; }
    
    self.highlightView = [[UIView alloc] initWithFrame:self.bounds];
    [self.highlightView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    self.highlightView.layer.cornerRadius = self.layer.cornerRadius;
    [self addSubview:self.highlightView];    
}

- (void)unhighlight {
    [self.highlightView removeFromSuperview];
    self.highlightView = nil;
}

- (void)sizeToFit {
    [super sizeToFit];
    [self kpa_modifyBoundsSize:kpa_sizeByAddingSizes(self.bounds.size, CGSizeMake(50, 0))];
}

@end
