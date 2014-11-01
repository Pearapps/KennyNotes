//
//  KPANoteAdditionButtonView.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/13/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPANoteAdditionalButtonView.h"
#import "KPAKit.h"
#import "KPANote.h"

@implementation KPANoteAdditionalButtonView

- (instancetype)initWithNote:(KPANote *)note withTypes:(NSArray *)buttonTypes; {
    self = [super init];
    if (self) {
        self.currentButtonTypes = buttonTypes;
      //  self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setCurrentButtonTypes:(NSArray *)currentButtonTypes {
    _currentButtonTypes = [currentButtonTypes copy];
    [self didSetTheButtonTypes];
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self didSetTheButtonTypes];
}

- (void)didSetTheButtonTypes {
    __block CGSize targetSize = CGSizeMake(0, 0);
    
    [self.currentButtonTypes enumerateObjectsUsingBlock:^(NSNumber *buttonType, NSUInteger idx, BOOL *stop) {
        
        UIButton *newButton = (UIButton *)[self viewWithTag:[buttonType integerValue]];
        
        if (!newButton) { newButton = [self addButtonOfType:[buttonType integerValue]]; }
        
        [newButton kpa_resizeBoundsInRelationToBounds:CGRectMake(0, 0, 125/2.f, 92/2.f) withPercentage:KPA2dValueMake(self.scale, self.scale)];
        
        targetSize.width += CGRectGetWidth(newButton.bounds);
        
        if (idx > 0) { targetSize.width += 5; }
        
        if (CGRectGetHeight(newButton.bounds) > targetSize.height) {
            targetSize.height = CGRectGetHeight(newButton.bounds);
        }
        
    }];
    
    self.bounds = CGRectMake(0, 0, targetSize.width, targetSize.height);
    [self orderAndLayout];
}

- (CGRect)frameForButtonType:(KPAAdditionalButtonType)type {
    return [[self viewWithTag:type] frame];
}

- (UIButton *)addButtonOfType:(KPAAdditionalButtonType)type {
    UIButton *picturedButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [picturedButtton setImage:[UIImage imageNamed:[self imageNamedForButtonType:type]] forState:UIControlStateNormal];
    [picturedButtton sizeToFit];
    
    [self addSubview:picturedButtton];
    picturedButtton.tag = type;
    [picturedButtton addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    return picturedButtton;
}

- (NSString *)imageNamedForButtonType:(KPAAdditionalButtonType)type {
    if (type == KPAAdditionalButtonTypePicture) { return @"pic.png"; }
    return @"keyboardDown.png";
}

- (void)orderAndLayout {
    CGFloat currentOffset = 0;
    for (NSNumber *buttonType in self.currentButtonTypes) {
        UIButton *buttonToPosition = (UIButton *)[self viewWithTag:[buttonType integerValue]];
        [buttonToPosition setCenter:CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(buttonToPosition.bounds)/2 - currentOffset, CGRectGetHeight(self.bounds)/2)];
        
        currentOffset += 5;
        currentOffset += CGRectGetWidth(buttonToPosition.bounds);
        
    }
    //[picture kpa_positionViewInView:self withPercentage:KPA2dValueMake(1.0, 1.0) doesAllowEscapingViewBounds:NO];
    
}

- (void)didSelect:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectButtonType:)]) {
        [self.delegate didSelectButtonType:sender.tag];
    }
    
}

@end