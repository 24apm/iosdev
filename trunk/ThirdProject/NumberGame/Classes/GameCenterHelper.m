//
//  GameCenterHelper.m
//  NumberGame
//
//  Created by MacCoder on 3/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameCenterHelper.h"
#import "UserData.h"
#import "GameConstants.h"

@interface GameCenterHelper()

@property (nonatomic, strong) NSString *identifier;

@end

@implementation GameCenterHelper

+ (GameCenterHelper *)instance {
    static GameCenterHelper *instance = nil;
    if (!instance) {
        instance = [[GameCenterHelper alloc] init];
    }
    return instance;
}

- (void) checkAchievements
{
    double percentComplete = 100;
    float currentScore = [UserData instance].maxScore;
    if(DEBUG_MODE) {
        currentScore = 1000;
    }
    if (currentScore >= 1) {
        self.identifier= kAchievementOneStreak;
        self.imgName = @"Achievementx1.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 6) {
        self.identifier= kAchievement5Streak;
        self.imgName = @"Achievementx5.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 11) {
        self.identifier= kAchievement10Streak;
        self.imgName = @"Achievementx10.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 16) {
        self.identifier= kAchievement15Streak;
        self.imgName = @"Achievementx15.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 21) {
        self.identifier= kAchievement20Streak;
        self.imgName = @"Achievementx20.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 31) {
        self.identifier= kAchievement30Streak;
        self.imgName = @"Achievementx30.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 41) {
        self.identifier= kAchievement40Streak;
        self.imgName = @"Achievementx40.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 51) {
        self.identifier= kAchievement50Streak;
        self.imgName = @"Achievementx50.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 61) {
        self.identifier= kAchievement60Streak;
        self.imgName = @"Achievementx60.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 76) {
        self.identifier= kAchievement75Streak;
        self.imgName = @"Achievementx75.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 91) {
        self.identifier= kAchievement90Streak;
        self.imgName = @"Achievementx90.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 116) {
        self.identifier= kAchievement115Streak;
        self.imgName = @"Achievementx115.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 131) {
        self.identifier= kAchievement130Streak;
        self.imgName = @"Achievementx130.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 151) {
        self.identifier= kAchievement150Streak;
        self.imgName = @"Achievementx150.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 171) {
        self.identifier= kAchievement170Streak;
        self.imgName = @"Achievementx170.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 201) {
        self.identifier= kAchievement200Streak;
        self.imgName = @"Achievementx200.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 251) {
        self.identifier= kAchievement250Streak;
        self.imgName = @"Achievementx250.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 351) {
        self.identifier= kAchievement350Streak;
        self.imgName = @"Achievementx350.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 501) {
        self.identifier= kAchievement500Streak;
        self.imgName = @"Achievementx500.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
    if (currentScore >= 1000) {
        self.identifier= kAchievement999Streak;
        self.imgName = @"Achievementx999WtN.png";
        [self.gameCenterManager submitAchievement: self.identifier percentComplete: percentComplete];
    }
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error; {
    
    if((error == NULL) && (ach != NULL))
    {
        if (ach.percentComplete == 100.0) {
            if ([self.identifier isEqualToString:ach.identifier]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ACHIEVETMENT_EARNED object:self.imgName];
            }
        }
        
    }
    else
    {
        // Achievement Submission Failed.
        
    }
}

- (void)onLocalPlayerScoreReceived:(GKScore *)score {
    [super onLocalPlayerScoreReceived:score];
    if ([UserData instance].maxScore > score.value) {
        [[UserData instance] submitScore:[UserData instance].maxScore];
    } else {
        [UserData instance].maxScore = score.value;
    }
}

@end
