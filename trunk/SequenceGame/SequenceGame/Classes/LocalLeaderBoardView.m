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
      [[NSNotificationCenter defaultCenter] postNotificationName:RETRY_BUTTON_NOTIFICATION object:self];
}

- (IBAction)topButtonPressed:(UIButton *)sender {
      [[NSNotificationCenter defaultCenter] postNotificationName:TOP_BUTTON_NOTIFICATION object:self];
}

- (void)initializeLeaderBoard {
    NSArray *localLeaderBoardMemory = [[UserData instance] loadLocalLeaderBoard];
    int step;
    double newEntry = [UserData instance].currentScore;
    for (step = 0; step < localLeaderBoardMemory.count; step++) {
        UILabel *scoreText = [self.labelScores objectAtIndex:step];
        double score = [[localLeaderBoardMemory objectAtIndex:step] doubleValue];
        scoreText.text = [NSString stringWithFormat:@"%.3F", score];
        if (score == newEntry) {
            scoreText.textColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f];
        } else {
        scoreText.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        }
    }
    [UserData instance].currentScore = 0;
    if (step < self.labelScores.count) {
        for (;step < self.labelScores.count; step++) {
            UILabel *scoreText = [self.labelScores objectAtIndex:step];
            double score = 0;
            scoreText.text = [NSString stringWithFormat:@"%.3F", score];
            scoreText.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        }
    }
}
@end
