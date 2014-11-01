//
//  KPANotesCache.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/25/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPANote.h"

@interface KPANotesCache : NSObject

- (KPANote *)noteWithKey:(NSNumber *)key withLoadableKeysBlock:(NSArray * (^)())block;

- (void)clearCache;

- (void)removeNoteFromCache:(KPANote *)note;

- (void)addNoteToCache:(KPANote *)note;

@end
