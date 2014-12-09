//
//  KPAKitGeometryFunctions.c
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAKitGeometryFunctions.h"

CGSize kpa_sizeByAddingSizes(CGSize size, CGSize otherSize) {
    return CGSizeMake(size.width + otherSize.width, size.height + otherSize.height);
}

CGSize kpa_sizeByMultiplying(CGSize size, CGFloat multiplier) {
    return CGSizeMake(size.width * multiplier, size.height * multiplier);
}

CGPoint kpa_midpoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}