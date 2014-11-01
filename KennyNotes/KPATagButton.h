//
//  KPATagButton.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/23/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPATag.h"

@class KPATagButton;
@protocol KPATagButtonDelegate <NSObject>

- (void)didResizeButton:(KPATagButton *)tagButton;

- (void)didCreateTag:(KPATag *)tag fromButton:(KPATagButton *)tagButton;

- (void)wantsToRemoveButton:(KPATagButton *)tagButton;

@end

@interface KPATagButton : UIButton

- (void)addTextField;

@property (nonatomic, strong) KPATag *associatedTag;

@property (nonatomic, readonly) UITextField *textField;

@property (nonatomic, assign) id <KPATagButtonDelegate> delegate;

@end
