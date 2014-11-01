//
//  KPATagController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/20/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPAKit.h"
#import "KPANote.h"
#import "KPATag.h"

@interface KPATagController : NSObject

+ (instancetype)controller;

- (void)removeAllTagsFromNote:(KPANote *)note;

- (NSArray *)tagsForNote:(KPANote *)note;

- (NSArray *)noteIDsForTag:(KPATag *)tag;

- (void)setTags:(NSArray *)tags forNote:(KPANote *)note;

- (void)removeAndDeleteTagFromAllNotes:(KPATag *)tag;

- (void)didSetNotesArchivedTo:(BOOL)isArchived withNote:(KPANote *)note;

- (NSMutableArray *)allTagIDsWithIsArchived:(BOOL)isArchived;


- (void)addTagToRemovalList:(KPATag *)tag;

- (void)checkRemovalList;

@end
