//
//  KPATagContainerView.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/23/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPATagContainerView.h"
#import "KPATagButton.h"
#import "KPAKit.h"
#import "KPABorderedAdditionButton.h"
#import "KPANote.h"

@interface KPATagContainerView () <KPATagButtonDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) KPABorderedAdditionButton *additionButton;

@end

@implementation KPATagContainerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mainScrollView = [UIScrollView new];
        [self addSubview:self.mainScrollView];
        [self.mainScrollView setBackgroundColor:[UIColor clearColor]];
        [self.mainScrollView setShowsHorizontalScrollIndicator:NO];
        
        self.additionButton = [KPABorderedAdditionButton borderedButtonWithBorderWidth:2 andBorderColor:[UIColor greenColor] andBorderRadius:0];
        [self.mainScrollView addSubview:self.additionButton];
        self.additionButton.additionColor = [UIColor greenColor];
        self.additionButton.additionSignLineWidth = 2.0;
        [self.additionButton addTarget:self action:@selector(addedButton) forControlEvents:UIControlEventTouchUpInside];
        [self.additionButton setBackgroundColor:[UIColor darkGrayColor]];
        
        self.buttons = [NSMutableArray new];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)resignTheTextFields {
    for (KPATagButton *button in self.buttons) {
        if (button.textField) {
            [button.textField resignFirstResponder];
            return;
        }
    }
}

- (void)setCurrentNote:(KPANote *)currentNote {
    _currentNote = currentNote;
    [[self buttons] removeAllObjects];
    for (KPATag *tag in [currentNote allTags]) {
        KPATagButton *button = [[KPATagButton alloc] init];
        [button setAssociatedTag:tag];
        [button addTarget:self action:@selector(tagButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:button];
        [self.buttons addObject:button];
    }
    [self setNeedsLayout];
}

- (void)addedButton {
    KPATagButton *button = [[KPATagButton alloc] init];
    button.delegate = self;
    [button addTarget:self action:@selector(tagButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button addTextField];
    [self.buttons addObject:button];
    [button.textField becomeFirstResponder];
    [self setNeedsLayout];
    [self.mainScrollView scrollRectToVisible:button.frame animated:NO];
}

- (void)tagButtonTapped:(KPATagButton *)sender {
    [self.delegate didSelectTagButton:sender];
}

- (void)removeTagButton:(KPATagButton *)tagButton {
    [self wantsToRemoveButton:tagButton];
}

- (void)wantsToRemoveButton:(KPATagButton *)tagButton {
    [self.buttons removeObject:tagButton];
    [tagButton removeFromSuperview];
    [self setNeedsLayout];
}

- (void)didResizeButton:(KPATagButton *)tagButton {
    [self setNeedsLayout]; // layoutSubviews
    [self.mainScrollView scrollRectToVisible:tagButton.frame animated:NO];
}

- (void)didCreateTag:(KPATag *)tag fromButton:(KPATagButton *)tagButton {
    if ([self.currentNote containsTag:tag]) {
        [self wantsToRemoveButton:tagButton];
    } else {
        [self.delegate didCreateNewTag:tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    [self.additionButton kpa_modifyBoundsSize:CGSizeMake(CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
    self.additionButton.center = CGPointMake(0 + CGRectGetWidth(self.additionButton.bounds)/2, CGRectGetHeight(self.bounds)/2);
    
    CGFloat currentOffset = CGRectGetWidth(self.additionButton.bounds);
    
    for (KPATagButton *button in self.buttons) {
        [button kpa_modifyBoundsSize:CGSizeMake(CGRectGetWidth(button.bounds), CGRectGetHeight(self.bounds))];
        [button setCenter:CGPointMake(currentOffset + CGRectGetWidth(button.bounds)/2, CGRectGetHeight(self.bounds)/2)];
        currentOffset += CGRectGetWidth(button.bounds);
    }
    
    [self.mainScrollView setContentSize:CGSizeMake(currentOffset, CGRectGetHeight(self.bounds))];
    
}

@end
