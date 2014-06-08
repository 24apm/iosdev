//
//  UnitView.m
//  Evolution
//
//  Created by MacCoder on 5/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UnitView.h"
#import "Utils.h"

@implementation UnitView

- (NSArray *)idleImages {
    return
    @[[UIImage imageNamed:@"tier9-2.png.png"],
      [UIImage imageNamed:@"tier9.png.png"]];
}

- (NSArray *)runningImages {
    return
    @[[UIImage imageNamed:@"tier12.png"],
      [UIImage imageNamed:@"tier12-2.png"]];
}

- (void)doPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNIT_VIEW_TAPPED object:self];
}

- (CFTimeInterval)idleDuration {
    return [Utils randBetweenMin:1.0f max:5.0f];
}

- (int)speed {
    return [Utils randBetweenMin:1.0f max:3.0f];
}

@end