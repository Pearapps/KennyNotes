//
//  KPABorderedAdditionButton.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/13/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPABorderedAdditionButton.h"

@implementation KPABorderedAdditionButton

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; };
    self.additionSignLineWidth = 1.0;
    return self;
}

- (void)setAdditionSignLineWidth:(CGFloat)additionSignLineWidth {
    _additionSignLineWidth = additionSignLineWidth;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGContextMoveToPoint(context, width * 0.2, height*0.5);

    CGContextAddLineToPoint(context, width * 0.8, height*0.5);
    
    CGContextMoveToPoint(context, width * 0.5, height * 0.2);
    
    CGContextAddLineToPoint(context, width * 0.5, height * 0.8);
    
    CGContextSetLineWidth(context, self.additionSignLineWidth);
    
    CGContextSetStrokeColorWithColor(context, self.additionColor.CGColor);
    
    CGContextStrokePath(context);
    
}


@end
