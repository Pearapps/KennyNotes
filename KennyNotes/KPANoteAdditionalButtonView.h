//
//  KPANoteAdditionButtonView.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/13/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KPAAdditionalButtonType) {
    KPAAdditionalButtonTypePicture = 1,
    KPAAdditionalButtonTypeLowerKeyboard = 2,
};

@protocol KPANoteAdditionalButtonViewDelegate <NSObject>

- (void)didSelectButtonType:(KPAAdditionalButtonType)buttonType;

@end


@class KPANote;
@interface KPANoteAdditionalButtonView : UIView

- (instancetype)initWithNote:(KPANote *)note withTypes:(NSArray *)buttonTypes;

- (CGRect)frameForButtonType:(KPAAdditionalButtonType)type;

@property (nonatomic, weak) id <KPANoteAdditionalButtonViewDelegate> delegate;

@property (nonatomic, copy) NSArray *currentButtonTypes;

@property (nonatomic, assign) CGFloat scale;

@end
