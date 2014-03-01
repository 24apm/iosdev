//
//  ProgressBarComponent.m
//  NumberGame
//
//  Created by MacCoder on 2/23/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ProgressBarComponent.h"

@implementation ProgressBarComponent

- (void)awakeFromNib {
    [super awakeFromNib];
    [self fillBar:1.f];
    self.clipsToBounds = YES;
}

- (void)fillBar:(CGFloat)percentage animated:(BOOL)animated {
    CGRect frame = self.backgroundView.frame;
    frame.size.width = self.backgroundView.frame.size.width * percentage;
    
    if (animated) {
        [UIView animateWithDuration:1.0f animations:^ {
            self.foregroundView.frame = frame;
        }];
    } else {
        self.foregroundView.frame = frame;
    }
}

- (void)fillBar:(CGFloat)percentage {
    [self fillBar:percentage animated:NO];
}

@end
