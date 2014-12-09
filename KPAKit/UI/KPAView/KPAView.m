//
//  KPAView.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAView.h"

@implementation KPAView

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    if (self.boundsChangeBlock) { self.boundsChangeBlock(bounds); }
}

- (void)dealloc {
    self.boundsChangeBlock = nil;
}

@end