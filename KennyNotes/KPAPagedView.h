//
//  KPAPagedView.h
//
//  Created by Kenneth Parker Ackerson on 4/29/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView * (^KPAPagedViewLoadViewblock)(NSUInteger index);

typedef void (^KPAPagedViewUpdateBlock)(NSArray *viewsToUpdate, NSArray *respectiveIndiciesOfViews);

@interface KPAPagedView : UIView

/**
 * @discussion Designated initializer.
 * @param frame The frame of the paged view.
 * @param pageNum The amount of pages in the paged view
 * @param block This is the block called to load the pages in the paged view.
 */
- (instancetype)initWithFrame:(CGRect)frame withNumberOfPages:(NSUInteger)pageNum andViewLoadingBlock:(KPAPagedViewLoadViewblock)block;

/**
 * @discussion This block will be called when updateViews is called, and well the view is initiated. The purpose of this is allow you to make changes to data representations in a view without having to reallocate them via the view loading block
 */
@property (nonatomic, copy) KPAPagedViewUpdateBlock viewUpdateBlock;

@property (nonatomic, readonly) UIScrollView *scroll;


/**
 * @discussion This method will call the view loading block provided at init, as well as the viewUpdateBlock if it is non-nil. This is used to reload all views that exist.
 */
- (void)reloadAll;

/**
 * @discussion This method will call the viewUpdateBlock if it is non-nil on each view that exists.
 */
- (void)updateViews;

/**
 * @discussion This will remove unessecary views in memory if they exist.
 */
- (void)flushUnessecaryViews;

@end
