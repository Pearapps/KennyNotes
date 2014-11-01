//
//  KPANote.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "FCModel.h"
#import "KPANoteImage.h"
#import "KPATag.h"

@interface KPANote : FCModel

@property (nonatomic, assign) NSInteger noteID; // Primary key

@property (nonatomic, assign) BOOL isArchived;

@property (nonatomic, copy) NSString *note; // Note contents

@property (nonatomic, strong) NSDate *creationTime;

@property (nonatomic, strong) NSDate *updatedTime;

@property (nonatomic, copy) NSString *truncatedNote;

- (void)archive;
- (void)restore;

#pragma mark Image Methods -

@property (nonatomic, copy) NSString *encodedImageIDs;

- (NSArray *)imagesWithThumbnails:(BOOL)thumbnails;

- (void)addImage:(KPANoteImage *)image;

- (void)removeImageWithID:(NSInteger)ID;

- (NSArray *)thumbnailImages;

- (NSArray *)allImageIDs;

#pragma mark 

#pragma mark Tag Methods -

- (NSArray *)allTags;

- (BOOL)containsTag:(KPATag *)tag;

- (void)addTag:(KPATag *)tag;

- (void)removeTag:(KPATag *)tag;

#pragma mark

@end
