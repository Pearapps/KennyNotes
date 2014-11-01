//
//  KPAActionSelectorView.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/11/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPAView.h"

typedef NS_OPTIONS(NSUInteger, KPAActionSheetSelectionType)  {
    KPAActionSheetSelectionTypeMail = 1 << 0,
};

@protocol KPAActionSelectorViewDelegate <NSObject>

@optional
- (void)didSelect:(KPAActionSheetSelectionType)selectedAction;

@end

@interface KPAActionSelectorView : KPAView

- (instancetype)initWithFrame:(CGRect)frame andSelectionTypes:(KPAActionSheetSelectionType)selectionTypes;

@property (nonatomic, assign) id <KPAActionSelectorViewDelegate> delegate;

@end
