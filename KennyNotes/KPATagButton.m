//
//  KPATagButton.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/23/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPATagButton.h"
#import "KPAKit.h"
#import "KPAThemeController.h"

@interface KPATagButton () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation KPATagButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor kpa_systemBlue];
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setNeedsLayout];
    }
    return self;
}

- (void)setAssociatedTag:(KPATag *)associatedTag {
    _associatedTag = associatedTag;
    
    [self setTitle:associatedTag.name forState:UIControlStateNormal];
    [self didChangeText:nil];
    //[self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.textField) {
        [self kpa_modifyBoundsSize:CGSizeMake([self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width+20, CGRectGetHeight(self.bounds))];
    }
    
    [self.textField setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [self.textField kpa_positionViewInBounds:self.bounds withPercentage:KPA2dValueMake(0.5, 0.5) doesAllowEscapingViewBounds:NO];
    
}

- (void)sendDelegateMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didResizeButton:)]) {
        [self.delegate didResizeButton:self];
    }
}

- (void)addTextField {
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    textField.keyboardAppearance = [[KPAThemeController controller] currentKeyboardAppearance];
    textField.delegate = self;
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField addTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
    self.textField = textField;
    self.textField.textColor = [UIColor whiteColor];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  //self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self didChangeText:nil];
}

- (void)didChangeText:(id)sender {
    if (self.textField) {
        [self layoutSubviews];
    } else {
        [self sizeToFit];
        [self kpa_modifyBoundsSize:CGSizeMake([self kpa_boundsSize].width + 20, [self kpa_boundsSize].height)];
    }
    [self sendDelegateMessage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setTitle:textField.text forState:UIControlStateNormal];
    
    NSString *theText = self.textField.text;
    theText = [theText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self.textField removeFromSuperview];
    self.textField = nil;
    
    if (theText.length > 0) {
        KPATag *tag = [KPATag firstInstanceWhere:@"name = (?)", theText];
        if (!tag) {
            tag = [[KPATag alloc] init];
            tag.name = theText;
            NSLog(@"Needs new tag");
        }
        self.associatedTag = tag;
        [self didChangeText:nil];
        [self.delegate didCreateTag:tag fromButton:self];
    } else {
        [self.delegate wantsToRemoveButton:self];
    }

}

@end