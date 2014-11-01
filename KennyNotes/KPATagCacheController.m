//
//  KPATagCacheController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 7/27/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPATagCacheController.h"
#import "KPATagController.h"

@interface KPATagCacheController ()

@property (nonatomic, strong) NSMutableArray *tagIDs;

@end

@implementation KPATagCacheController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kpa_didReceiveMemWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)kpa_didReceiveMemWarning {
    self.tagIDs = nil;
}

- (void)clear {
    self.tagIDs = nil;
}

- (NSMutableArray *)tagIDs {
    if (!_tagIDs) {
        _tagIDs = [NSMutableArray new];
        [_tagIDs addObjectsFromArray:[[KPATagController controller] allTagIDsWithIsArchived:NO]];
    }
    return _tagIDs;
}

- (NSArray *)allTagIDs {
    return self.tagIDs;
}

@end
