//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

@interface UserData : NSObject

@property (nonatomic, retain) UIImage *lastGameSS;
@property (nonatomic) BOOL tutorialModeEnabled;
@property (nonatomic) double currentScore;

+ (UserData *)instance;
- (void)resetLocalScore :(NSString *)mode;
- (NSArray *)loadLocalLeaderBoard :(NSString *)mode;
- (void)addNewScoreLocalLeaderBoard:(double)newScores mode:(NSString *)mode;
- (void)resetLocalLeaderBoard;

@property (nonatomic, strong) NSString *currentEquippedItem;

@end
