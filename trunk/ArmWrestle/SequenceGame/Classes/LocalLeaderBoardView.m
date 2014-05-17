//
//  LocalLeaderBoardView.m
//  SequenceGame
//
//  Created by MacCoder on 3/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LocalLeaderBoardView.h"
#import "UserData.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "iRate.h"
#import "TrackUtils.h"

@implementation LocalLeaderBoardView

- (void)show {
    [self initializeLeaderBoard];
    self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
}

- (IBAction)retryButtonPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"iRate" label:@"ratePressed"];
    [[iRate sharedInstance] openRatingsPageInAppStore];
}

- (IBAction)topButtonPressed:(UIButton *)sender {
      [[NSNotificationCenter defaultCenter] postNotificationName:TOP_BUTTON_NOTIFICATION object:self];
}

- (void)initializeTitleBoard {
    if ([[GameManager instance].gameMode isEqualToString:GAME_MODE_SINGLE]) {
        self.leaderBoardLabel.text = @"YOUR BEST TIME";
        self.leaderBoardLabel.textColor = kCOLOR_RED;
        self.retryButton.backgroundColor = kCOLOR_RED;
    }
}

- (void)initializeLeaderBoard {
    NSArray *localLeaderBoardMemory = [[UserData instance] loadLocalLeaderBoard:[GameManager instance].gameMode];
    int step;
    [self initializeTitleBoard];
    NSString *format;
    if ([[GameManager instance].gameMode isEqualToString:GAME_MODE_SINGLE]) {
        format = @"%.3F";
         self.currentScore.text = [NSString stringWithFormat:@"Current: %.3F", [UserData instance].currentScore];
    } else {
        format = @"%.0F";
         self.currentScore.text = [NSString stringWithFormat:@"Current: %.0F", [UserData instance].currentScore];
    }
    BOOL notFound = YES;
    double newEntry = [UserData instance].currentScore;
    for (step = 0; step < localLeaderBoardMemory.count && step < self.labelScores.count; step++) {
        UILabel *scoreText = [self.labelScores objectAtIndex:step];
        double score = [[localLeaderBoardMemory objectAtIndex:step] doubleValue];
        scoreText.text = [NSString stringWithFormat:format, score];
        if (score == newEntry && notFound) {
            if ([[GameManager instance].gameMode isEqualToString:GAME_MODE_SINGLE]) {
                scoreText.textColor = kCOLOR_RED;
            } else {
                scoreText.textColor = kCOLOR_BLUE;
            }
            notFound = NO;
        } else {
            scoreText.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        }
    }
    
    [self fillerScore:step];
}

- (void) fillerScore: (int)step {
    [UserData instance].currentScore = 0;
    if (step < self.labelScores.count) {
        for (;step < self.labelScores.count; step++) {
            UILabel *scoreText = [self.labelScores objectAtIndex:step];
            double score = 0;
            scoreText.text = [NSString stringWithFormat:@"%.0F", score];
            scoreText.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        }
    }
}
@end
