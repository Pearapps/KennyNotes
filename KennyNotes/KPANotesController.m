//
//  KPANoteController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPANotesController.h"
#import "KPAKit.h"
#import "KPANotesCache.h"
#import "KPATagController.h"

@interface KPANotesController ()

@property (nonatomic, strong) NSMutableArray *orderArray;

@property (nonatomic, strong) KPANotesCache *cache;

@property (nonatomic, assign) BOOL isDisplayingArchived;

@property (nonatomic, assign) BOOL shouldSaveOrderedArray;

@property (nonatomic, strong) NSArray *tempOrderArray;


@end

@implementation KPANotesController

- (void)setAssociatedTag:(KPATag *)associatedTag {
    _associatedTag = associatedTag;
    if (associatedTag) {
        [self loadOrderedArrayWithTag];
    }
}

- (void)loadOrderedArrayWithTag {
    
    NSArray *noteIDs = [[KPATagController controller] noteIDsForTag:self.associatedTag];
    [self.cache clearCache];
    [[self orderArray] removeAllObjects];
    [[self orderArray] addObjectsFromArray:noteIDs];
    NSLog(@"%@ -- order array %@", self.associatedTag, self.orderArray);
    
}

- (void)loadOrderedArray {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *oderedOnFile = [NSArray arrayWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"order"]];
    [self.orderArray addObjectsFromArray:oderedOnFile];
}

- (void)loadOrderedArrayForArchived {
    [KPANote inDatabaseSync:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT noteID from KPANote where isArchived = 1"];
        
        while ([rs next]) {
            [self.orderArray addObject:[rs objectForColumnIndex:0]];
        }
        
    }];
    
}

- (void)loadOrderedArrayForTagID {
    [KPANote inDatabaseSync:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT noteID from KPANote where isArchived = 0 AND "];
        
        while ([rs next]) {
            [self.orderArray addObject:[rs objectForColumnIndex:0]];
        }
        
    }];
    
}

- (void)sharedInitWithDoesDisplayArchived:(BOOL)displaysArchived {
    
    self.isDisplayingArchived = displaysArchived;
    
    self.orderArray = [NSMutableArray new];
    
    self.cache = [KPANotesCache new];
    
    self.shouldSaveOrderedArray = !displaysArchived;
    
}

- (instancetype)initWithAsscociatedTag:(KPATag *)tag {
    self = [super init];
    
    if (!self) { return nil; }
    
    [self sharedInitWithDoesDisplayArchived:NO];
    
    [self setAssociatedTag:tag];
    
    self.shouldSaveOrderedArray = NO;
    
    return self;
}

- (instancetype)initWithDisplayArchive:(BOOL)displaysArchived {
    self = [super init];
    
    if (!self) { return nil; }
    
    [self sharedInitWithDoesDisplayArchived:displaysArchived];
    
    if (!self.isDisplayingArchived) {
        [self loadOrderedArray];
    } else {
        [self loadOrderedArrayForArchived];
    }
    
    return self;
}

- (KPANote *)noteForIndexPath:(NSIndexPath *)path {
    return [self.cache noteWithKey:self.orderArray[path.row] withLoadableKeysBlock:^NSArray * {
        NSInteger startingIndex = path.row;
        if (path.row > 15) {
            startingIndex -= 15;
        } else {
            startingIndex = 0;
        }
        NSInteger length = 30;
        if (self.orderArray.count <= 15) {
            length = self.orderArray.count;
        }
        if (startingIndex + length > self.orderArray.count) {
            length -= (startingIndex + length) - self.orderArray.count;
        }
        
        return [self.orderArray subarrayWithRange:NSMakeRange(startingIndex, length)];
    }];
    {
        //    NSNumber *key = self.orderArray[path.row];
        //    NSInteger keyNumber = [key integerValue];
        //
        //    for (KPANote *note in self.notes) {
        //        if (note.noteID == keyNumber) {
        //            return note;
        //        }
        //    }
        //
        //    if (self.notes.count >= 60) {
        //        [self.notes removeObjectsInRange:NSMakeRange(0, 30 + (self.notes.count - 60))];
        //    }
        //
        //    NSInteger startingIndex = path.row;
        //
        //    if (path.row > 15) {
        //        startingIndex -= 15;
        //    } else {
        //        startingIndex = 0;
        //    }
        //
        //    NSInteger length = 30;
        ////    if (self.orderArray.count - path.row < 15) {
        ////        length = self.orderArray.count - path.row;
        ////        length+=(15);
        ////    }
        //
        //    if (self.orderArray.count <= 15) {
        //        length = self.orderArray.count;
        //    }
        //
        //    if (startingIndex + length > self.orderArray.count) {
        //        length -= (startingIndex + length) - self.orderArray.count;
        //    }
        //
        //    NSArray *keys = [self.orderArray subarrayWithRange:NSMakeRange(startingIndex, length)];
        //    NSDictionary* keyed = [KPANote keyedInstancesWithPrimaryKeyValues:[self.orderArray subarrayWithRange:NSMakeRange(startingIndex, length)]];
        //
        //    for (NSNumber *key in keys) {
        //        [self.notes addObject:keyed[key]];
        //    }
        //
        //    return [self noteForIndexPath:path];
    }
}

- (void)deleteNoteAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *key = self.orderArray[indexPath.row];
    KPANote *noteToDelete = [KPANote instanceWithPrimaryKey:key];
    [noteToDelete delete];
    [self.orderArray removeObject:key];
    
    if (self.associatedTag) {
        [self removeNoteID:noteToDelete.noteID];
    }
    
    [self saveOrderArray];
    [[self cache] removeNoteFromCache:noteToDelete];
}

- (void)archiveNoteAtIndexPath:(NSIndexPath *)indexPath {
    KPANote *note = [self noteForIndexPath:indexPath];
    [note archive];
    [self.orderArray removeObject:@(note.noteID)];
    
    if (self.associatedTag) {
        [self removeNoteID:note.noteID];
    }
    
    [self saveOrderArray];
    [[self cache] removeNoteFromCache:note];
}

- (void)restoreNoteAtIndexPath:(NSIndexPath *)indexPath {
    KPANote *note = [self noteForIndexPath:indexPath];
    [note restore];
    [self.orderArray removeObject:@(note.noteID)];
    [self restoredNoteID:note.noteID];
    [[self cache] removeNoteFromCache:note];
}

- (void)switchNoteAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to  {
    id temp = self.orderArray[from.row];
    [self.orderArray removeObjectAtIndex:from.row];
    [self.orderArray insertObject:temp atIndex:to.row];
    [self saveOrderArray];
}

- (NSUInteger)amountOfNotes {
    return self.orderArray.count;
}

#pragma mark - Private -

- (void)saveOrderArray {
    if (self.isDisplayingArchived) {
        return;
    }
    
    if (!self.shouldSaveOrderedArray) {
        return;
    }
    
    NSLog(@"save order array");
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self.orderArray writeToFile:[documentsPath stringByAppendingPathComponent:@"order"] atomically:YES];
}

#pragma - KPANoteVCDelegate -

- (void)didSaveNewNote:(KPANote *)note {
    [self.orderArray insertObject:@([note noteID]) atIndex:0];
    [self saveOrderArray];
    
    if (self.associatedTag) {
        [self restoredNoteID:note.noteID]; // This is too add to the normal order array, even though its called restored
    }
    
    [self updateViewController];
}

- (void)removedNote:(KPANote *)note {
    [self.orderArray removeObject:@(note.noteID)];
    if (self.associatedTag) {
        [self removeNoteID:note.noteID];
    }
    [self saveOrderArray];
    [self updateViewController];
}

- (void)didUpdateNote:(KPANote *)note {
    [self updateViewController];
}

- (void)startSearch {
    self.tempOrderArray = [self.orderArray copy];
    self.shouldSaveOrderedArray = NO;
}

- (void)stopSearch {
    //[self.cache clearCache];
    [self.orderArray removeAllObjects];
    self.orderArray = [self.tempOrderArray mutableCopy];
    self.shouldSaveOrderedArray = YES;
    [self updateViewController];
    self.tempOrderArray = nil;
}

- (void)searchWithQueryString:(NSString *)query {
    
    //[self.cache clearCache];
    [self.orderArray removeAllObjects];
    
    if (query.length == 0) {
        if (!self.associatedTag && !self.isDisplayingArchived) {
            [self loadOrderedArray];
        } else if (self.associatedTag) {
            [self loadOrderedArrayForTagID];
        } else {
            [self loadOrderedArrayForArchived];
        }
        [self updateViewController];
        return;
    }
    
    [KPANote inDatabaseSync:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT noteID from KPANote where truncatedNote like ? and isArchived = 0", [NSString stringWithFormat:@"%%%@%%", query]];
        while ([rs next]) {
            [self.orderArray addObject:[rs objectForColumnIndex:0]];
        }
        
    }];
    
    [self.orderArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSInteger indexInOrderOfOne = [self.tempOrderArray indexOfObject:obj1];
        NSInteger indexInOrderOfTwo = [self.tempOrderArray indexOfObject:obj2];
        
        if (indexInOrderOfOne == indexInOrderOfTwo) {
            return NSOrderedSame;
        }
        
        if (indexInOrderOfOne > indexInOrderOfTwo) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
        
    }];
    
    [self updateViewController];
}

#pragma mark - Private -

- (void)updateViewController {
    [self.delegate updatedDataSource];
}

- (void)restoredNoteID:(NSInteger)noteID { // this sucks
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSMutableArray *arr = [[NSArray arrayWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"order"]] mutableCopy];
    [arr insertObject:@(noteID) atIndex:0];
    [arr writeToFile:[documentsPath stringByAppendingPathComponent:@"order"] atomically:YES];
}

- (void)removeNoteID:(NSInteger)noteID {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSMutableArray *arr = [[NSArray arrayWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"order"]] mutableCopy];
    [arr removeObject:@(noteID)];
    [arr writeToFile:[documentsPath stringByAppendingPathComponent:@"order"] atomically:YES];
}

@end