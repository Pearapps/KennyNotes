//
//  KPANoteImageDisplayView.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/13/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPANote, KPANoteImage;
@protocol KPANoteImageDisplayViewDelegate <NSObject>

- (void)requestAdditionalImageForNote:(KPANote *)note;

- (void)didSelectImageID:(NSInteger)imageID withViewOfSelectedImage:(UIView *)view;

@end

@interface KPANoteImageDisplayView : UIView

@property (nonatomic, weak) id <KPANoteImageDisplayViewDelegate> delegate;

- (void)addImage:(KPANoteImage *)image;

- (instancetype)initWithNote:(KPANote *)note;

- (void)refresh;

- (void)readjustBounds;

- (void)reloadImages;

@end
