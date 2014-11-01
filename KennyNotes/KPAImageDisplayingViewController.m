//
//  KPAImageDisplayingViewController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/16/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAImageDisplayingViewController.h"
#import "KPASharedImageController.h"
#import "KPAThemeController.h"
#import "KPAPagedView.h"
#import "PhotoViewController.h"
#import "KPANote.h"

@interface KPAImageDisplayingViewController () <UIScrollViewDelegate, UIPageViewControllerDataSource>

@property (nonatomic, assign) NSInteger imageID;

@property (nonatomic, strong) KPAPagedView *pageView;

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, weak) KPANote *currentNote;

@end

@implementation KPAImageDisplayingViewController

- (id)initWithImageID:(NSInteger)imageID andNote:(KPANote *)note {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.imageID = imageID;
        self.currentNote = note;
    }
    return self;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc {
    NSInteger index = vc.pageIndex;
    
    if (index == 0) {
        return nil;
    }
    
    return [PhotoViewController photoViewControllerWithPageIndex:(index - 1) andImageLoadingBlock:[self block]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc {
    NSInteger index = vc.pageIndex;
    
    if (index + 1 >= [self.currentNote allImageIDs].count) {
        return nil;
    }
    
    return [PhotoViewController photoViewControllerWithPageIndex:(index + 1) andImageLoadingBlock:[self block]];
}

- (UIImage * (^)(NSUInteger i))block {
    
    return ^UIImage * (NSUInteger index) {
        NSString *stringID = [self.currentNote allImageIDs][[self.currentNote allImageIDs].count - 1 - index];
        
        return [[KPASharedImageController controller] imageWIthID:[stringID integerValue] wantsThumb:NO];
    
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image";
    
    [self.view setBackgroundColor:[[KPAThemeController controller] currentBackgroundColor]];
    
    [[KPAThemeController controller] themeViewController:self];

    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)]];
    
    NSLog(@"%@ -- %ld", [self.currentNote allImageIDs], (long)self.imageID);
    
    // kick things off by making the first page
    PhotoViewController *pageZero = [PhotoViewController photoViewControllerWithPageIndex:[self.currentNote allImageIDs].count - 1 - [[self.currentNote allImageIDs] indexOfObject:[@(self.imageID) stringValue]] andImageLoadingBlock:[self block]];
    if (pageZero) {
        // assign the first page to the pageViewController (our rootViewController)
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageViewController.dataSource = self;
      //  self.pageViewController.view.backgroundColor = [UIColor greenColor];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController setViewControllers:@[pageZero] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    }
  
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return [scrollView viewWithTag:4554];
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    [self centerScrollViewContents:scrollView];
//}
//
//// Modified from http://stackoverflow.com/questions/13184038/how-to-center-uiimageview-in-scrollview-zooming
//- (void)centerScrollViewContents:(UIScrollView *)scrollView {
//    CGSize boundsSize = scrollView.bounds.size;
//    CGRect contentsFrame = [scrollView viewWithTag:4554].frame;
//    
//    if (contentsFrame.size.width < boundsSize.width) {
//        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
//    } else {
//        contentsFrame.origin.x = 0.0f;
//    }
//    
//    if (contentsFrame.size.height < boundsSize.height) {
//        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
//    } else {
//        contentsFrame.origin.y = 0.0f;
//    }
//
//    [scrollView viewWithTag:4554].frame = contentsFrame;
//}
//
@end
