//
//  KPAView.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPAKitDefinitions.h"

@interface KPAView : UIView

/**
 * @property boundsChangeBlock This is the block.
 * @discussion This is the block that is called when the bounds change. It will pass the new bounds value. Don't change the bounds of this view in this block.
 */
@property (nonatomic, copy) KPABoundsBlock boundsChangeBlock;

@end
