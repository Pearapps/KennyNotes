//
//  NSNumber+KPAKit.m
//  KPAKitProject
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "NSNumber+KPAKit.h"

@implementation NSNumber (KPAKit)

- (void)kpa_repititions:(KPAIntegerBlock)block {
    for (NSInteger i = 1; i <= [self integerValue]; i++) {
        block(i);
    }
}

@end
