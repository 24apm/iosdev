//
//  CharacterView.m
//  Evolution
//
//  Created by MacCoder on 5/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CharacterView.h"

@implementation CharacterView

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

- (void)reset {
    self.state = UnitViewStateAnimateIdle;
}

- (CFTimeInterval)idleDuration {
    return 3.f;
}

@end
