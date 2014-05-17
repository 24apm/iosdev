//
//  NumberGameView.h
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "THLabel.h"
#import "GameLayoutView.h"

#define GAMEPLAY_VIEW_DISMISSED_NOTIFICATION @"GAMEPLAY_VIEW_DISMISSED_NOTIFICATION"

@interface GamePlayView : XibView

@property (strong, nonatomic) IBOutlet GameLayoutView *gameLayoutView;
@property (strong, nonatomic) IBOutlet UIButton *replayButton;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;

- (void)show;
- (void)refreshGame;

@end
