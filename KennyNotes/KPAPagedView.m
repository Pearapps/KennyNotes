//
//  KPAPagedView.m
//
//  Created by Kenneth Parker Ackerson on 4/29/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAPagedView.h"

@interface KPAPagedView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) NSMutableDictionary *views;

@property (nonatomic, assign) NSUInteger pageNum;

@property (nonatomic, copy) KPAPagedViewLoadViewblock viewLoadBlock;

@end

@implementation KPAPagedView

- (void)dealloc {
    self.pageControl = nil;
    self.scroll = nil;
    self.views = nil;
    self.viewUpdateBlock = nil;
    self.viewLoadBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame withNumberOfPages:(NSUInteger)pageNum andViewLoadingBlock:(KPAPagedViewLoadViewblock)block {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (!block) {
            [NSException raise:@"Block is nil" format:@"Can not pass a nil block"];
        }
        
        self.viewLoadBlock = block;
        self.pageNum = pageNum;
        
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:self.scroll];
        [self.scroll setPagingEnabled:YES];
        self.scroll.delegate = self;
        self.scroll.showsHorizontalScrollIndicator = NO;
        [self.scroll setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * self.pageNum, CGRectGetHeight(self.frame))];
        [self.scroll setScrollsToTop:NO];
        
        self.views = [[NSMutableDictionary alloc] initWithCapacity:self.pageNum];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width, 20)];
        [self addSubview:self.pageControl];
        [self.pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:0.6 alpha:0.7]];
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];
        [self.pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
        [self.pageControl setCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-CGRectGetHeight(self.pageControl.frame)/2 - 5)];
        self.pageControl.numberOfPages = pageNum;
        
        [self loadViewonIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kpa_didReceiveMemWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    return self;
}

- (void)updateViews {
    if (self.viewUpdateBlock) {
        
        NSMutableArray *ma = [[NSMutableArray alloc] init];
        NSMutableArray *indicies = [[NSMutableArray alloc] init];
        
        for (id key in [self.views allKeys]) {
            [ma addObject:self.views[key]];
            [indicies addObject:key];
        }
        
        self.viewUpdateBlock(ma, indicies);
        
    }
}

- (void)flushUnessecaryViews { // Not 100% good and will only work if it is not being changed
    
    if (self.views.count == 0 || self.views.count == 1) {
        return;
    }
    
    if (self.scroll.isTracking && self.scroll.isDragging && self.scroll.isDecelerating) {
        return;
    }
    
    for (NSInteger i = 0; i < self.pageNum; i++) {
        
        if ((NSInteger)self.scroll.contentOffset.x == (i * CGRectGetWidth(self.frame))) {
            if (i == self.pageControl.currentPage) {
                
                for (NSInteger x = 0; x < self.pageNum; x++) {
                    
                    if (x == i) {
                        continue;
                    }
                    
                    [self unloadViewAtIndex:x];
                    
                }
                
                break;
            }
        }
    }
    
}

- (void)reloadAll {
    for (id key in [self.views allKeys]) {
        UIView *view = self.views[key];
        [view removeFromSuperview];
    }
    
    [self.views removeAllObjects];
    
    [self scrollViewDidScroll:self.scroll];
    [self loadViewonIndex:self.pageControl.currentPage];
}

- (void)setViewUpdateBlock:(KPAPagedViewUpdateBlock)viewUpdateBlock {
    _viewUpdateBlock = [viewUpdateBlock copy];
    if (_viewUpdateBlock) {
        [self updateViews];
    }
}

#pragma mark - Private -

- (void)kpa_didReceiveMemWarning {
    [self flushUnessecaryViews];
}

- (void)pageControlClicked:(UIPageControl *) sender {
    NSInteger page = sender.currentPage;
    CGRect frame = self.scroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scroll scrollRectToVisible:frame animated:YES];
}

- (void)unloadViewAtIndex:(NSUInteger)index {
    UIView *view = self.views[@(index)];
    if (view) {
        [view removeFromSuperview];
        [self.views removeObjectForKey:@(index)];
    }
}

- (void)loadViewonIndex:(NSInteger)indexToLoad {
    if (indexToLoad >= self.pageNum || indexToLoad < 0) {
        return;
    }
    
    UIView *newView = self.views[@(indexToLoad)];
    
    if (!newView) {
        newView = self.viewLoadBlock(indexToLoad);
    }
    
    if (![newView superview]) {
        [self.scroll addSubview:newView];
        if (self.viewUpdateBlock) {
            self.viewUpdateBlock(@[newView], @[@(indexToLoad)]);
        }
    } else {
        return;
    }
    
    [newView setCenter:CGPointMake(CGRectGetWidth(self.frame)/2 + indexToLoad * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2.f)];
    
    self.views[@(indexToLoad)] = newView;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    if (page - 2 >= 0) {
        [self unloadViewAtIndex:page-2];
    }
    
    if (page + 2 < self.pageNum) {
        [self unloadViewAtIndex:page+2];
    }
    
    if (scrollView.contentOffset.x > page * CGRectGetWidth(self.frame)) {
        
        [self loadViewonIndex:page+1];
        
    } else if (scrollView.contentOffset.x < page * CGRectGetWidth(self.frame)) {
        [self loadViewonIndex:page-1];
    }
    
    self.pageControl.currentPage = page;
}


@end
