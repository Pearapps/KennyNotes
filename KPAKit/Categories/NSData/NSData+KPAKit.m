//
//  NSData+KPAKit.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "NSData+KPAKit.h"
#import "KPAKit.h"

@implementation NSData (KPAKit)

+ (void)kpa_dataWithContentsOfURL:(NSURL *)url withData:(void (^)(NSData *data))dataBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        kpa_dispatch_async_with_object(dispatch_get_main_queue(), dataBlock, data);
    });
}

@end
