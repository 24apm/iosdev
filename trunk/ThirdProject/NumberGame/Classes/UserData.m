//
//  UserData.m
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UserData.h"
#import "GameCenterHelper.h"

@implementation UserData

+ (UserData *)instance {
    static UserData *instance = nil;
    if (!instance) {
        instance = [[UserData alloc] init];
        instance.maxScore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"maxScore"] intValue];
    }
    return instance;
}

- (void)setScore:(int)score {
    _score = score;
}

- (void)setMaxScore:(int)maxScore {
    if (maxScore > _maxScore) {
        _maxScore = maxScore;
        [self saveUserData];
    }
}

- (void)saveUserData{
    [self submitScore:self.maxScore];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@(self.maxScore) forKey:@"maxScore"];
    [defaults synchronize];
}

- (void)submitScore:(int)score {
    if(score > 0) {
        [[GameCenterHelper instance].gameCenterManager reportScore:score forCategory: [GameCenterHelper instance].currentLeaderBoard];
    }
}


@end
