//
//  KPAKitFuncs.c
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/17/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAKitGeneralFunctions.h"

void kpa_dispatch_async_with_object(dispatch_queue_t queue, KPAObjectBlock block, id obj) {
    dispatch_async(queue, ^{ block(obj); });
}

void kpa_dispatch_async_with_pointer(dispatch_queue_t queue, KPAPointerBlock block, void *x) {
    dispatch_async(queue, ^{ block(x); });
}