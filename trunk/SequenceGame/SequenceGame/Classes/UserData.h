//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

@interface UserData : NSObject

@property (nonatomic) int score;
@property (nonatomic) int maxScore;
@property (nonatomic, retain) UIImage *lastGameSS;
@property (nonatomic) BOOL tutorialModeEnabled;
@property (nonatomic) double currentScore;

+ (UserData *)instance;
- (void)submitScore:(int)score;
- (void)resetLocalScore;
- (NSArray *)loadLocalLeaderBoard;
- (void)addNewScoreLocalLeaderBoard:(double)newScores;
- (void)resetLocalLeaderBoard;
@end
