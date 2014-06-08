//
//  CharacterView.m
//  Evolution
//
//  Created by MacCoder on 5/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CharacterView.h"

@implementation CharacterView

- (void)step {
    [super step];
    switch (self.state) {
        case UnitViewStateAnimateAttacking:   // x1
            [self animateAttacking];
            break;
        case UnitViewStateAttacking:          // x999
            [self doAttack];
            break;
        default:
            break;
    }
}

- (void)animateAttacking {
    [self.characterImageView stopAnimating];
    self.characterImageView.image = [UIImage imageNamed:@"RushyKnightIcon120.png"];
    self.idleTime = CACurrentMediaTime() + 1.0f;
    self.state = UnitViewStateAttacking;
}

- (void)doAttack {
    if (CACurrentMediaTime() > self.idleTime) {
        self.state = UnitViewStateAnimateIdle;
    }
}


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