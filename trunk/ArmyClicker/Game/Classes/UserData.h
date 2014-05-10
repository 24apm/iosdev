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
@property (nonatomic) int currentCoin;

+ (UserData *)instance;
- (void)submitScore:(int)score mode:(NSString *)mode;
- (void)resetLocalScore :(NSString *)mode;
- (NSArray *)loadLocalLeaderBoard :(NSString *)mode;
- (void)addNewScoreLocalLeaderBoard:(double)newScores mode:(NSString *)mode;
- (void)resetLocalLeaderBoard;
- (void)saveUserCoin;
- (void)retrieveUserCoin;

@property (nonatomic, strong) NSString *currentEquippedItem;

@end