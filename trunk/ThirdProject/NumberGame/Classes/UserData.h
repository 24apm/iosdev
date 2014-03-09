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

+ (UserData *)instance;
- (void)submitScore:(int)score;

@end
