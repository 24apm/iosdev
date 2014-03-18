//
//  NumberGameView.h
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "MonsterView.h"
#import "THLabel.h"
#import "GameLayoutView.h"

#define GAMEPLAY_VIEW_DISMISSED_NOTIFICATION @"GAMEPLAY_VIEW_DISMISSED_NOTIFICATION"

@interface GamePlayDistanceView : XibView

@property (strong, nonatomic) IBOutlet GameLayoutView *gameLayoutView;
@property (nonatomic) int score;
- (void)show;
- (void)refreshGame;

@end
