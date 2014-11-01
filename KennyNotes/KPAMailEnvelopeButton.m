//
//  KPAMailEnvelopeButton.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/11/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAMailEnvelopeButton.h"
#import "UIColor+KPAKit.h"

@interface KPAMailEnvelopeButton ()


@end

@implementation KPAMailEnvelopeButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect envelopeRect = CGRectMake(0.5, 0.5, CGRectGetWidth(self.bounds)-1, 29);
    
    CGPoint envelopeMeetingPoint = CGPointMake(CGRectGetWidth(envelopeRect)*0.5, CGRectGetHeight(envelopeRect)*0.7);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, [self currentColorToDrawWith].CGColor);
    CGContextStrokeRect(context, envelopeRect);
    CGContextSetLineWidth(context, 1);

    CGContextSetLineJoin(context, kCGLineJoinRound);

    CGContextMoveToPoint(context, 0.0f, 0.0f); //start at this point

    CGContextAddLineToPoint(context, envelopeMeetingPoint.x, envelopeMeetingPoint.y); //draw to this point

    CGContextAddLineToPoint(context, CGRectGetWidth(envelopeRect), 0.0f); //draw to this point
    
    CGContextStrokePath(context);
    
}

@end