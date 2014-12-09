//
//  NSArray+KPAKit.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (KPAKit)

/**
 * @param indexSet This is the index set used to get the subarray. Will not check that all indices are in the array so be careful.
 * @return A subarray of this array of the passed index set.
 */
- (NSArray *)kpa_subarrayWithIndexSet:(NSIndexSet *)indexSet;

/**
 * @param predicate This is used to check which objects to get in the subarray.
 * @return A subarray of this array of objects that pass the predicate block.
 */
- (NSArray *)kpa_subarrayOfObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

@end
