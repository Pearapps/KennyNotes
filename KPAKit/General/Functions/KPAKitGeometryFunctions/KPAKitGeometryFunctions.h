//
//  KPAKitGeometryFunctions.h
//  KPAKit
//
//  Created by Kenneth Parker Ackerson on 6/18/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

extern CGSize kpa_sizeByAddingSizes(CGSize size, CGSize otherSize);

extern CGSize kpa_sizeByMultiplying(CGSize size, CGFloat multiplier);

extern CGPoint kpa_midpoint(CGPoint p1, CGPoint p2);