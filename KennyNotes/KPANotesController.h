//
//  KPANoteController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPANote.h"
#import "KPANoteViewController.h"

@protocol KPANotesControllerDelegate <NSObject>

- (void)updatedDataSource;

@end

@interface KPANotesController : NSObject <KPANoteVCDelegate>

- (instancetype)initWithDisplayArchive:(BOOL)displaysArchived;
- (instancetype)initWithAsscociatedTag:(KPATag *)tag;

- (KPANote *)noteForIndexPath:(NSIndexPath *)path;

- (void)deleteNoteAtIndexPath:(NSIndexPath *)indexPath;

- (void)switchNoteAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to;

- (NSUInteger)amountOfNotes;

- (void)archiveNoteAtIndexPath:(NSIndexPath *)indexPath;
- (void)restoreNoteAtIndexPath:(NSIndexPath *)indexPath;

- (void)searchWithQueryString:(NSString *)query;

- (void)startSearch;
- (void)stopSearch;

@property (nonatomic, weak) id <KPANotesControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL isDisplayingArchived;
@property (nonatomic, strong) KPATag *associatedTag;

@end
