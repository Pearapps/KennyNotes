//
//  KPANoteImageDisplayView.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/13/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPANoteImageDisplayView.h"
#import "KPAKit.h"
#import "KPABorderedAdditionButton.h"
#import "KPANote.h"

@interface KPANoteImageDisplayView ()

@property (nonatomic, weak) KPANote *currentNote;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UIView *bubbleView;

@property (nonatomic, strong) KPABorderedAdditionButton *addButton;

@property (nonatomic, strong) UIScrollView *imageScrollView;

@end

@implementation KPANoteImageDisplayView

- (instancetype)initWithNote:(KPANote *)note {
    
    self = [self initWithImages:[note thumbnailImages]];
    
    if (!self) { return nil; }
    
    self.currentNote = note;
    
    [self readjustBounds];
    
    return self;
    
}

- (instancetype)initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.opaque = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bubbleIshView = [[UIView alloc] init];
        [bubbleIshView setBackgroundColor:[UIColor kpa_systemBlue]];
        [[bubbleIshView layer] setCornerRadius:10];
        //[bubbleIshView setCenter:CGPointMake(CGRectGetWidth(self.bounds)/2, )]
        [self addSubview:bubbleIshView];
        
        self.bubbleView = bubbleIshView;
        
        KPABorderedAdditionButton *addButton = (KPABorderedAdditionButton *)[KPABorderedAdditionButton borderedButtonWithBorderWidth:1 andBorderColor:[UIColor greenColor] andBorderRadius:5];
        [addButton kpa_modifyBoundsSize:CGSizeMake(48, 48)];
        [bubbleIshView addSubview:addButton];
        addButton.additionColor = [UIColor greenColor];
        addButton.highlightOnSelection = YES;
        
        [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        
        self.addButton = addButton;
        
        [self loadUpImages];
        
        self.imageScrollView = [[UIScrollView alloc] init];
        [self.bubbleView addSubview:self.imageScrollView];
        
        [self readjustBounds];
        
    }
    return self;
}

- (void)reloadImages {
    [self refresh];
}

- (void)loadUpImages {
    
    [[[self imageScrollView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.images = nil;
    self.images = [NSMutableArray new];
    
    for (KPANoteImage *image in [self.currentNote thumbnailImages]) {
        NSLog(@"image in thumb %@", image);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button kpa_modifyBoundsSize:CGSizeMake(48, 48)];
        [self.images addObject:button];
        [button setTag:image.imageID];
        [button addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageScrollView addSubview:button];
        
        UILongPressGestureRecognizer *longPressGestureRecongnizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [button addGestureRecognizer:longPressGestureRecongnizer];
        
    }
}

// http://stackoverflow.com/questions/10938223/how-can-i-create-an-cabasicanimation-for-multiple-properties
- (void)longPressed:(UILongPressGestureRecognizer *)gestureRecong {
    UIButton *button = (UIButton *)[gestureRecong view];
    if (gestureRecong.state == UIGestureRecognizerStateEnded) {
        
        if ([[button layer] animationForKey:@"k"]) {
            [[button layer] removeAnimationForKey:@"k"];
            return;
        }
        
        
        [[button layer] addAnimation:[self getShakeAnimation] forKey:@"k"];
    }
}

- (CAAnimation*)getShakeAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CGFloat wobbleAngle = 0.06f;
    NSValue* valLeft = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0f, 0.0f, 1.0f)];
    NSValue* valRight = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0f, 0.0f, 1.0f)];
    animation.values = @[valLeft, valRight];
    animation.autoreverses = YES;
    animation.duration = 0.125;
    animation.repeatCount = HUGE_VALF;
    return animation;
}


- (void)readjustBounds {
    [self loadUpImages];
    
    CGFloat maxWidth = 55 + self.images.count * 55;
    
    [self setBounds:CGRectMake(0, 0, (maxWidth > 300 ? 300 : maxWidth), 62)];
    
    // TODO: Make scalable
    
    if (self.frame.origin.x < 0) {
        [self setBounds:CGRectMake(0, 0, (maxWidth > 250 ? 250 : maxWidth), 62)];
    }
    
    
    [self.bubbleView setBounds:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 55)];
    
    
    [self.addButton kpa_positionViewInBounds:self.bubbleView.bounds withPercentage:KPA2dValueMake(0.5, 0.5) doesAllowEscapingViewBounds:NO];
    [self.addButton setCenter:CGPointMake(CGRectGetWidth(self.bubbleView.bounds) - CGRectGetWidth(self.addButton.bounds)/2 - 3.5, self.addButton.center.y)];
    
    
    [self.imageScrollView setBounds:CGRectMake(0, 0, CGRectGetWidth(self.bubbleView.bounds) - 55-3.5, 55)];
    [self.imageScrollView setCenter:CGPointMake(self.addButton.center.x - CGRectGetWidth(self.addButton.bounds)/2 - CGRectGetWidth(self.imageScrollView.bounds)/2 - 4, CGRectGetHeight(self.imageScrollView.bounds)/2)];
    [self.imageScrollView setContentSize:CGSizeMake(maxWidth - 55, 55)];
    
    
    [self.images enumerateObjectsUsingBlock:^(UIButton *imageView, NSUInteger idx, BOOL *stop) {
        
        [imageView setCenter:CGPointMake(self.imageScrollView.contentSize.width - (idx * 55)- 55/2.f, self.addButton.center.y)];
        
    }];
    
    [self.bubbleView kpa_positionViewInBounds:self.bounds withPercentage:KPA2dValueMake(0.5, 0) doesAllowEscapingViewBounds:NO];
    
    [self.imageScrollView setContentOffset:CGPointMake(fabs(CGRectGetWidth(self.imageScrollView.bounds) - self.imageScrollView.contentSize.width), 0)];
    
    [self setNeedsDisplay];
}

- (void)selectedImage:(UIButton *)sender {
    //    [self becomeFirstResponder];
    //    [[UIMenuController sharedMenuController] setTargetRect:[self convertRect:sender.frame fromView:self.imageScrollView] inView:self];
    //    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    //    [self.images enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
    //
    //    }];
    NSLog(@"selectedImage:");
    if ([[sender layer] animationForKey:@"k"]) {
        [[sender layer] removeAnimationForKey:@"k"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectImageID:withViewOfSelectedImage:)]) {
        [self.delegate didSelectImageID:sender.tag withViewOfSelectedImage:sender];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL result = NO;
    if (@selector(copy:) == action) {
        result = YES;
    }
    return result;
}

- (void)refresh {
    [self readjustBounds];
}

- (void)add:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestAdditionalImageForNote:)]) {
        [self.delegate requestAdditionalImageForNote:self.currentNote];
    }
}

- (void)addImage:(KPANoteImage *)image {
    [self readjustBounds];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat closetTrianglePoint = width - 20;
    CGFloat farthestTrianglePoint = width - 10;
    
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGContextMoveToPoint(context, closetTrianglePoint, 55);
    
    CGContextAddLineToPoint(context, (closetTrianglePoint+farthestTrianglePoint)/2.f, height);
    
    CGContextAddLineToPoint(context, farthestTrianglePoint, 55);
    
    CGContextAddLineToPoint(context, closetTrianglePoint, 55);
    
    [[UIColor kpa_systemBlue] setFill];
    
    CGContextFillPath(context);
    
}

@end
