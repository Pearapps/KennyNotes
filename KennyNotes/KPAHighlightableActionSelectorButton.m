//
//  KPAHighlightableActionSelectorButton.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/12/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAHighlightableActionSelectorButton.h"

@interface KPAHighlightableActionSelectorButton ()

@property (nonatomic, strong) UIColor *currentColorToDrawWith;

@end

@implementation KPAHighlightableActionSelectorButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentColorToDrawWith = [UIColor lightGrayColor];
        
        [self addTarget:self action:@selector(didTapDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return self;
}

- (void)setCurrentColorToDrawWith:(UIColor *)currentColorToDrawWith {
    _currentColorToDrawWith = currentColorToDrawWith;
    [self setNeedsDisplay];
}

- (void)didTapDown:(id)sender {
    self.currentColorToDrawWith = [UIColor darkGrayColor];
}

- (void)didTouchUp:(id)sender {
    self.currentColorToDrawWith = [UIColor lightGrayColor];
}

- (void)drawRect:(CGRect)rect {
    NSString *text = self.kpa_buttonTitle;
    
    if (!text) {
        return;
    }
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [self currentColorToDrawWith]};
    
    CGSize size = [text sizeWithAttributes:attribs];
    
    [text drawAtPoint:CGPointMake(CGRectGetWidth(self.bounds)/2-size.width/2, CGRectGetHeight(self.bounds) - size.height) withAttributes:attribs];
}

@end
