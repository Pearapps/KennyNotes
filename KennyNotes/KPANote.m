//
//  KPANote.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPANote.h"
#import "KPASharedImageController.h"
#import "KPANoteImage.h"
#import "KPATagController.h"
#import "FCModel.h"

@interface KPANote ()

@property (nonatomic, strong) NSMutableArray *imageIDs;

//@property (nonatomic, strong) NSMutableArray *thumbnails;

@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation KPANote

- (FCModelSaveResult)delete {
    
    for (KPATag *tag in self.tags) {
        [[KPATagController controller] addTagToRemovalList:tag];
    }
    
    [[KPATagController controller] removeAllTagsFromNote:self]; // Order of these operations is very important.
    
    [[KPATagController controller] checkRemovalList];
    
    
    [[KPASharedImageController controller] addImagesToRemovalList:self.imageIDs];
    
    [[KPASharedImageController controller] checkRemovalList];
    
    return [super delete];
}

- (FCModelSaveResult)save {
    
    if (_tags) { [[KPATagController controller] setTags:_tags forNote:self]; }
    
    [_tags makeObjectsPerformSelector:@selector(save)];
    
    [[KPATagController controller] checkRemovalList];
    
    [[KPASharedImageController controller] checkRemovalList];
    
    return [super save];
}

- (void)archive {
    self.isArchived = YES;
    [[KPATagController controller] didSetNotesArchivedTo:YES withNote:self];
    [self save];
}

- (void)restore {
    self.isArchived = NO;
    [[KPATagController controller] didSetNotesArchivedTo:NO withNote:self];
    [self save];
}

- (NSMutableArray *)imageIDs {
    if (!_imageIDs) {
        self.imageIDs = [NSMutableArray new];
        if (self.encodedImageIDs.length > 0) {
            [self.imageIDs addObjectsFromArray:[self.encodedImageIDs componentsSeparatedByString:@","]];
        }
    }
    return _imageIDs;
}

- (void)setEncodedImageIDs:(NSString *)encodedImageIDs {
    _encodedImageIDs = [encodedImageIDs copy];
}

- (NSArray *)imagesWithThumbnails:(BOOL)thumbnails {
    __block NSArray *images = nil;
    // NSLog(@"%@", self.imageIDs);
    [[KPASharedImageController controller] getImagesForIDs:self.imageIDs onBlock:^(id object) {
        images = object;
    } wantsThumb:thumbnails];
    
    return images;
}

- (void)addImage:(KPANoteImage *)image {
    
    NSInteger ID = [[KPASharedImageController controller] addImage:image];
    
    NSNumber *numberID = @(ID);
    
    [self.imageIDs addObject:[numberID stringValue]];
    [self setEncodedImageIDs:[self.imageIDs componentsJoinedByString:@","]];
    //    NSLog(@"add image - %@", self.encodedImageIDs);
    
}

- (void)removeImageWithID:(NSInteger)ID {
    //  NSLog(@"removed image %@", @(ID));
    [[KPASharedImageController controller] addImageToRemovalList:ID];
    
    for (NSInteger i = 0; i < self.imageIDs.count; i++) {
        NSNumber *number = self.imageIDs[i];
        
        if (number.integerValue == ID) {
            [self.imageIDs removeObject:number];
            break;
        }
        
    }
    
    // [self.imageIDs removeObject:numberID];
    [self setEncodedImageIDs:[self.imageIDs componentsJoinedByString:@","]];
    
    if (self.imageIDs.count == 0) {
        [self setEncodedImageIDs:@""];
    }
    
    // [self save];
}

- (NSArray *)thumbnailImages {
    return [self imagesWithThumbnails:YES];
}

- (NSArray *)allImageIDs {
    return self.imageIDs;
}

- (NSArray *)allTags {
    return self.tags;
}

- (BOOL)containsTag:(KPATag *)tag {
    for (KPATag *t in self.tags) {
        if ([t.name isEqualToString:tag.name] && t.tagID == tag.tagID) {
            return YES;
        }
    }
    return NO;
}

- (void)addTag:(KPATag *)tag {
    [self.tags addObject:tag];
}

- (void)removeTag:(KPATag *)tag {
    [[KPATagController controller] addTagToRemovalList:tag];
    [self.tags removeObject:tag];
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray new];
        [_tags addObjectsFromArray:[[KPATagController controller] tagsForNote:self]];
    }
    return _tags;
}

@end