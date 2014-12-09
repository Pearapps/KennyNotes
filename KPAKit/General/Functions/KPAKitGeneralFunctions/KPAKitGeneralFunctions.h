//
//  KPAKitFuncs.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <dispatch/dispatch.h>
#import <objc/objc.h>
#import "KPAKitDefinitions.h"

extern void kpa_dispatch_async_with_object(dispatch_queue_t queue, KPAObjectBlock block, id obj);

extern void kpa_dispatch_async_with_pointer(dispatch_queue_t queue, KPAPointerBlock block, void *x);