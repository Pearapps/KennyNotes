//
//  KPAImageDisplayingViewController.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/16/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPANote;
@interface KPAImageDisplayingViewController : UIViewController

- (id)initWithImageID:(NSInteger)imageID andNote:(KPANote *)note;

@end
