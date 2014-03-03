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
    NSString* identifier = NULL;
    double percentComplete = 100;
    float currentScore = [UserData instance].score;
    if (currentScore >= 1) {
         identifier= kAchievementOneStreak;
    }
    if (currentScore >= 10) {
        identifier= kAchievement10Streak;
    }
    if(identifier!= NULL) {
        [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
    }
}
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error; {
    
    if((error == NULL) && (ach != NULL))
    {
        if (ach.percentComplete == 100.0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Achievement Earned!"
                                                            message:(@"%@",ach.identifier)
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        // Achievement Submission Failed.
        
    }
}
@end
