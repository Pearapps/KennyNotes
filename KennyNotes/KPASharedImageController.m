//
//  KPASharedImageController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/16/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPASharedImageController.h"
#import "KPAKit.h"
#import "FMDB.h"
#import "FCModel.h"
#import "UIImage+KPAAdditions.h"

@interface KPASharedImageController () <NSCacheDelegate>

@property (nonatomic, strong) NSCache *imageCache;

@property (nonatomic, strong) NSMutableArray *removalList;

@end

@implementation KPASharedImageController

+ (KPASharedImageController *)controller { KPACreateSingleton(^{ return [self new]; }); }

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    [self createImagesFolderIfPossible];
    self.imageCache = [NSCache new];
    self.imageCache.delegate = self;
    return self;
}

#pragma mark Image Removal Methods -

- (NSMutableArray *)removalList {
    if (!_removalList) {
        _removalList = [NSMutableArray new];
    }
    return _removalList;
}

- (void)addImageToRemovalList:(NSInteger)ID {
    [self.removalList addObject:@(ID)];
}

- (void)addImagesToRemovalList:(NSArray *)removalIDs {
    [self.removalList addObjectsFromArray:removalIDs];
}

- (void)checkRemovalList {
    for (NSNumber *number in self.removalList) {
        [self removeImageWithID:number.integerValue];
    }
    [self.removalList removeAllObjects];
    self.removalList = nil;
}

#pragma mark

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"%@", obj);
}

- (void)getImagesForIDs:(NSArray *)imageIDs onBlock:(KPAObjectBlock)block wantsThumb:(BOOL)wantsThumb {
    NSMutableArray *images = [NSMutableArray new];
    for (NSNumber *number in imageIDs) {
        [images addObject:[self imageWIthID:[number integerValue] wantsThumb:wantsThumb]];
    }
    block(images);
}

- (KPANoteImage *)imageWIthID:(NSInteger)ID wantsThumb:(BOOL)wantsThumb {
    
    NSString *key = [[NSString alloc] initWithFormat:@"%ld_%i", (long)ID, wantsThumb];
    
    id cachedImage = [self.imageCache objectForKey:key];
    if (cachedImage) { NSLog(@"Loaded from cache"); return cachedImage; }
    
    KPANoteImage *image = [[KPANoteImage alloc] initWithContentsOfFile:[self pathForImageID:ID wantsThumb:wantsThumb]];
    image.imageID = ID;
    [self.imageCache setObject:image forKey:key];
 //   NSLog(@"loaded images");
    return image;
}

- (NSInteger)addImage:(KPANoteImage *)image {
    NSInteger ID = 0;
    
    do {
        ID = arc4random_uniform((int)pow(2, 31));
        if (arc4random_uniform(2) == 0) { ID = -ID; }
    } while ([self imageIDExists:ID]);
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:[self pathForImageID:ID wantsThumb:NO] atomically:YES];
    
    UIImage *thumb = [image kpa_resizeImageProportionallyIntoNewSize:CGSizeMake(100, 100)];
    
    [UIImageJPEGRepresentation(thumb, 1) writeToFile:[self pathForImageID:ID wantsThumb:YES] atomically:YES];
    
    return ID;
}

- (void)removeImageWithID:(NSInteger)ID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[NSFileManager defaultManager] removeItemAtPath:[self pathForImageID:ID wantsThumb:NO] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[self pathForImageID:ID wantsThumb:YES] error:nil];
    });
}

#pragma mark - Private -

- (NSString *)pathForImageID:(NSInteger)ID wantsThumb:(BOOL)wantsThumb {
    NSString *pathCompon = [@(ID) stringValue];
    
    if (wantsThumb) {
        pathCompon = [pathCompon stringByAppendingString:@"thumb"];
    }

    return [[self sharedImageFolder] stringByAppendingPathComponent:pathCompon];
}

- (NSString *)sharedImageFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return [basePath stringByAppendingPathComponent:@"noteImages"];
}

- (BOOL)imageIDExists:(NSInteger)ID {
    return ([[NSFileManager defaultManager] fileExistsAtPath:[self pathForImageID:ID wantsThumb:NO]]);
}

- (BOOL)createImagesFolderIfPossible {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self sharedImageFolder] isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self sharedImageFolder] withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return (error == nil);
}

@end
