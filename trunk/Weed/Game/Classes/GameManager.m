//
//  GameManager.m
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameManager.h"
#import "GameConstants.h"

@implementation GameManager

+ (GameManager *)instance {
    static GameManager *instance = nil;
    if (!instance) {
        instance = [[GameManager alloc] init];
    }
    return instance;
}

- (void)addScore:(UserInput)input {
    switch (input) {
        case UserInputDefend:
            self.playerOneScore++;
            break;
        case UserInputAttack:
            self.playerTwoScore++;
            break;
        default:
            break;
    }
}

-(void)resetScore {
    self.playerTwoScore = 0;
    self.playerOneScore = 0;
}

-(Winner)calculateWinner {
    int winner = Tie;
    if (self.playerOneScore > self.playerTwoScore) {
        winner = PlayerOneWin;
    } else if (self.playerOneScore < self.playerTwoScore) {
     winner = PlayerTwoWin;
    }
    return winner;
}

- (NSArray *)currentVisibleQueue {
    NSRange range = NSMakeRange(self.step, MIN(self.unitQueue.count - self.step,4));
    return [self.unitQueue subarrayWithRange:range];
}

- (NSString *)imagePathForUserInput:(UserInput)userInput {
    switch (userInput) {
        case UserInputAttack:
            return @""; //@"attack.png";
            break;
        case UserInputDefend:
            return @""; //@"defend.png";
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)characterImageForFlapping {
    return @[@"character_flapdown.png", @"character_flapup.png"];
}

+ (NSString *)characterImageForFlying {
    return @"character_flying.png";
}

+ (NSString *)characterImageForFalling {
    return @"character_falling.png";
}

+ (NSString *)characterImageForStanding {
    return @"character_standing.png";
}

@end
