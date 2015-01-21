//
//  UserChoice.m
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "UserChoice.h"
#import "Utils.h"

@implementation UserChoice

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self shuffleID];
    }
    return self;
}

- (IBAction)buttonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_CHOICE_PRESSED object:self.label.title];
    [self shuffleID];
}

- (void)shuffleID {
    int randomInt = [Utils randBetweenMinInt:1 max:7];
    self.blockID = [NSString stringWithFormat:@"%d",randomInt];
    self.label.title  = self.blockID;
}
@end
