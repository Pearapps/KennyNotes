//
//  KPATagController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/20/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPATagController.h"
#import "FCModel.h"
#import "FMDB.h"

@interface KPATagController ()

@property (nonatomic, strong) NSMutableArray *removalList;

@end

@implementation KPATagController

+ (instancetype)controller { KPACreateSingleton(^{ return [self new]; }); }

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)addTag:(KPATag *)tag toNote:(KPANote *)note {
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO tagRegistry VALUES (?, ?, 0)", @(tag.tagID), @(note.noteID)];
    }];
}

- (void)removeTag:(KPATag *)tag fromNote:(KPANote *)note {
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM tagRegistry WHERE tagID = (?) AND noteID = (?)", @(tag.tagID), @(note.noteID)];
    }];
}

- (void)removeAllTagsFromNote:(KPANote *)note {
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM tagRegistry WHERE noteID = (?)", @(note.noteID)];
    }];
}

- (void)removeAndDeleteTagFromAllNotes:(KPATag *)tag {
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM tagRegistry WHERE tagID = (?)", @(tag.tagID)];
    }];
    [tag delete];
}

- (NSArray *)tagsForNote:(KPANote *)note {
    __block NSMutableArray *tagIDs = [NSMutableArray new];
    
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT tagID FROM tagRegistry WHERE noteID = (?)", @(note.noteID)];
        
        while ([rs next]) {
            [tagIDs addObject:[rs objectForColumnIndex:0]];
        }
        
    }];
    
    return [KPATag instancesWithPrimaryKeyValues:tagIDs];
}

- (NSArray *)noteIDsForTag:(KPATag *)tag {
    __block NSMutableArray *noteIDs = [NSMutableArray new];
    
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT DISTINCT noteID FROM tagRegistry WHERE tagID = (?) AND isArchived = 0", @(tag.tagID)];
        
        while ([rs next]) {
            [noteIDs addObject:[rs objectForColumnIndex:0]];
        }
        
    }];
    
    return noteIDs;
}

- (void)setTags:(NSArray *)tags forNote:(KPANote *)note {
    // NSLog(@"adding tags.... %@", tags);
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM tagRegistry WHERE noteID = (?)", @(note.noteID)];
        
        for (KPATag *tag in tags) {
            [db executeUpdate:@"INSERT INTO tagRegistry VALUES (?, ?, 0)", @(tag.tagID), @(note.noteID)];
        }
        
    }];
}

- (NSMutableArray *)allTagIDsWithIsArchived:(BOOL)isArchived {
    
    NSMutableArray *tagIDs = [NSMutableArray new];
    
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT DISTINCT tagID FROM tagRegistry WHERE isArchived = (?)", @((NSInteger)isArchived)];
        
        while ([rs next]) {
            [tagIDs addObject:[rs objectForColumnIndex:0]];
        }
        
    }];
    
    return tagIDs;
}

- (NSMutableArray *)removalList {
    if (!_removalList) {
        _removalList = [NSMutableArray new];
    }
    return _removalList;
}

- (void)addTagToRemovalList:(KPATag *)tag {
    [self.removalList addObject:tag];
}

- (void)didSetNotesArchivedTo:(BOOL)isArchived withNote:(KPANote *)note {
    NSInteger isA = isArchived;
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE tagRegistry set isArchived = (?) where noteID = (?)", @(isA), @(note.noteID)];
    }];
}

- (void)checkRemovalList {
    [FCModel inDatabaseSync:^(FMDatabase *db) {
       // NSLog(@"%@", self.removalList);
        for (KPATag *tag in self.removalList) {
            FMResultSet *rs = [db executeQuery:@"SELECT tagID FROM tagRegistry WHERE tagID = (?)", @(tag.tagID)];
            
            NSInteger tagsLogged = 0;
            
            while ([rs next]) {
                tagsLogged++;
            }
            
            if (tagsLogged == 0) {
                [tag delete];
            }
            
        }
    }];
    
    [self.removalList removeAllObjects];
    self.removalList = nil;
}


@end