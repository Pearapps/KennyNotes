//
//  KPAListViewController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPATag;
@interface KPAListViewController : UITableViewController

- (instancetype)initWithIsArchived:(BOOL)isArchived;

- (instancetype)initWithTag:(KPATag *)tag;

@end
