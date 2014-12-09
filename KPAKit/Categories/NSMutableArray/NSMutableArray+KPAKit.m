//
//  NSMutableArray+KPAKit.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 5/22/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "NSMutableArray+KPAKit.h"

@implementation NSMutableArray (KPAKit)

- (void)kpa_removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    [self removeObjectsAtIndexes:[self indexesOfObjectsPassingTest:predicate]];
}

@end