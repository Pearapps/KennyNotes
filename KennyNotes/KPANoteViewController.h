//
//  KPANoteViewController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPANote.h"
#import "KPAKit.h"

@protocol KPANoteVCDelegate <NSObject>

@optional
- (void)didSaveNewNote:(KPANote *)note;
- (void)didUpdateNote:(KPANote *)note;
- (void)removedNote:(KPANote *)note;

@end

@interface KPANoteViewController : UIViewController

- (id)initWithNote:(KPANote *)note;

@property (nonatomic, assign) id <KPANoteVCDelegate> delegate;

@end
