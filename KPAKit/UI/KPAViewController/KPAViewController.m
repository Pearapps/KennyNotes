//
//  KPAViewController.m
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 5/19/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAViewController.h"

@implementation KPAViewController

- (void)loadView {
    self.view = [[KPAView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (KPAView *)kpa_view {
    return (KPAView *)self.view;
}

@end