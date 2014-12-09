//
//  NSData+KPAKit.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (KPAKit)

+ (void)kpa_dataWithContentsOfURL:(NSURL *)url withData:(void (^)(NSData *data))dataBlock;

@end
