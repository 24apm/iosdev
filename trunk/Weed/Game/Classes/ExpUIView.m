//
//  ExpUIView.m
//  Make It Flappy
//
//  Created by MacCoder on 6/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ExpUIView.h"

@implementation ExpUIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self show];
    }
    return self;
}

- (void)show {
    self.expImage.hidden = NO;
    self.currentExpLabel.hidden = NO;
    self.tpsLabel.hidden = NO;
}

- (void)hide {
    self.expImage.hidden = YES;
    self.currentExpLabel.hidden = YES;
    self.tpsLabel.hidden = YES;
}

- (void)updateText {
    self.currentExpLabel.text = @"100";
}
@end
