//
//  KPACustomNoteTextView.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPACustomNoteTextView.h"

@implementation KPACustomNoteTextView

- (UIResponder *)nextResponder {
    if (_overrideNextResponder) {
        return _overrideNextResponder;
    }
    else {
        return [super nextResponder];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_overrideNextResponder) {
        return NO;
    }
    else {
        return [super canPerformAction:action withSender:sender];
    }
}

@end