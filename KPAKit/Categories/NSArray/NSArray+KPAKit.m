//
//  NSArray+KPAKit.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "NSArray+KPAKit.h"

@implementation NSArray (KPAKit)

- (NSArray *)kpa_subarrayWithIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *subArray  = [NSMutableArray new];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) { [subArray addObject:self[idx]]; }];
    return subArray;
}

- (NSArray *)kpa_subarrayOfObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    return [self kpa_subarrayWithIndexSet:[self indexesOfObjectsPassingTest:predicate]];
}

@end
