//
//  KPASharedImageController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/16/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPAKit.h"
#import "KPANoteImage.h"

@interface KPASharedImageController : NSObject

+ (KPASharedImageController *)controller;

// Returns the newly added image's ID
- (NSInteger)addImage:(KPANoteImage *)image;

- (void)removeImageWithID:(NSInteger)ID;

- (void)getImagesForIDs:(NSArray *)imageIDs onBlock:(KPAObjectBlock)block wantsThumb:(BOOL)wantsThumb;

- (KPANoteImage *)imageWIthID:(NSInteger)ID wantsThumb:(BOOL)wantsThumb;


// Image removal
- (void)addImageToRemovalList:(NSInteger)ID;

- (void)addImagesToRemovalList:(NSArray *)removalIDs;

- (void)checkRemovalList;

@end
