//
//  UserChoice.m
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "UserChoice.h"
#import "Utils.h"
#import "BlockManager.h"

@implementation UserChoice

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =[super initWithCoder:aDecoder];
    if (self) {
        //[self shuffleID];
    }
    return self;
}

- (IBAction)buttonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_CHOICE_PRESSED object:[NSNumber numberWithInteger:self.blockID ]];
    // [self shuffleID];
}

- (void)setChoiceID:(BlockType)type {
    self.blockID = (BlockType)type;
    self.backgroundColor = [BlockManager colorForBlockType:type];
    self.label.title  = @"";//[NSString stringWithFormat:@"%d",self.blockID];
}

- (void)shuffleID {
    NSInteger randomFruitType = [Utils randBetweenMinInt:BlockType_Apple max:BlockType_Lemon];
    self.blockID = randomFruitType;
    self.label.title  = [NSString stringWithFormat:@"%d",randomFruitType];
}

@end
