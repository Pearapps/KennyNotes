//
//  KPATagCacheController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/27/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPATagCacheController : NSObject

@property (nonatomic, readonly) NSArray *allTagIDs;

- (void)clear;

@end
