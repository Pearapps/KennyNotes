//
//  KPATagContainerView.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/23/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPATag, KPANote, KPATagButton;
@protocol KPATagContainerViewDelegate <NSObject>

- (void)didCreateNewTag:(KPATag *)tag;

- (void)didSelectTagButton:(KPATagButton *)tagButton;

@end

@interface KPATagContainerView : UIView

@property (nonatomic, weak) id <KPATagContainerViewDelegate> delegate;

@property (nonatomic, weak) KPANote *currentNote;

- (void)removeTagButton:(KPATagButton *)tagButton;

- (void)resignTheTextFields;

@end
