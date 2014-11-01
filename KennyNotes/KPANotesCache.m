//
//  KPANotesCache.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/25/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPANotesCache.h"

@interface KPANotesCache () <NSCacheDelegate>

@property (nonatomic, strong) NSCache *theCache;

@end

@implementation KPANotesCache

- (instancetype)init {
    self = [super init];
    
    if (!self) { return nil; }
    
    self.theCache = [NSCache new];
    self.theCache.delegate = self;
    
    return self;
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"%@", obj);
}

- (KPANote *)noteWithKey:(NSNumber *)key withLoadableKeysBlock:(NSArray * (^)())block {
    
    KPANote *note = [self.theCache objectForKey:key];
    
    if (note) { return note; }
    
    NSArray *notes = [KPANote instancesWithPrimaryKeyValues:block()];
    
    for (KPANote *note in notes) {
        [self.theCache setObject:note forKey:@(note.noteID)];
    }
    
    return [self.theCache objectForKey:key];
    
    {
        //    NSInteger keyNumber = [key integerValue];
        //
        //    for (KPANote *note in self.notes) { if (note.noteID == keyNumber) { return note; } }
        //
        //    if (self.notes.count >= 60) { [[self notes] removeObjectsInRange:NSMakeRange(0, 30 + (self.notes.count - 60))]; }
        //
        //    NSArray *keys = block();
        //    NSDictionary* keyed = [KPANote keyedInstancesWithPrimaryKeyValues:keys];
        //
        //    KPANote *noteToReturn = nil;
        //
        //    for (NSNumber *k in keys) {
        //        KPANote *newNote = keyed[k];
        //        if (!noteToReturn) {
        //            if ([k integerValue] == keyNumber) {
        //                noteToReturn = newNote;
        //            }
        //        }
        //        [self.notes addObject:newNote];
        //    }
        //
        //   // NSLog(@"%ld", (long)self.notes.count);
        //    if (noteToReturn) { return noteToReturn; }
        //
        //    return [self noteWithKey:key withLoadableKeysBlock:block];
    }
}

- (void)removeNoteFromCache:(KPANote *)note {
    [[self theCache] removeObjectForKey:@(note.noteID)];
}

- (void)addNoteToCache:(KPANote *)note {
    [[self theCache] setObject:note forKey:@(note.noteID)];
}

- (void)clearCache {
    [[self theCache] removeAllObjects];
}

- (void)dealloc {
    self.theCache = nil;
}

@end