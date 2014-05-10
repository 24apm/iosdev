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
#import "GameLayoutOneView.h"

#define GAMEPLAY_ONE_VIEW_DISMISSED_NOTIFICATION @"GAMEPLAY_ONE_VIEW_DISMISSED_NOTIFICATION"

@interface GamePlayOneView : XibView

@property (strong, nonatomic) IBOutlet GameLayoutOneView *gameLayoutView;
@property (strong, nonatomic) IBOutlet UIButton *replayButton;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;

- (void)show;
- (void)refreshGame;

@end
