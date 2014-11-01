//
//  KPATag.h
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/27/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCModel/FCModel.h"

@interface KPATag : FCModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger tagID;

@end
