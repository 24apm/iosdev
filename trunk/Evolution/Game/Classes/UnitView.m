//
//  UnitView.m
//  Evolution
//
//  Created by MacCoder on 5/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UnitView.h"

@implementation UnitView

- (NSArray *)idleImages {
    return
    @[[UIImage imageNamed:@"clicker_character1.png"],
      [UIImage imageNamed:@"clicker_character4.png"]];
}

- (NSArray *)runningImages {
    return
    @[[UIImage imageNamed:@"clicker_character1.png"],
      [UIImage imageNamed:@"clicker_character2.png"]];
}

- (void)doPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:UNIT_VIEW_TAPPED object:self];
}

- (CFTimeInterval)idleDuration {
    return 3.f;
}

@end
