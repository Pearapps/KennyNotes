//
//  KPACustomNoteTextView.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPACustomNoteTextView : UITextView

// http://stackoverflow.com/questions/8380373/showing-uimenucontroller-loses-keyboard
@property (nonatomic, weak) UIResponder *overrideNextResponder;

@end
