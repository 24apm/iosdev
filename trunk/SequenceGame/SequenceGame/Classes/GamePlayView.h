//
//  NumberGameView.h
//  NumberGame
//
//  Created by MacCoder on 2/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "MonsterView.h"

#define GAMEPLAY_VIEW_DISMISSED_NOTIFICATION @"GAMEPLAY_VIEW_DISMISSED_NOTIFICATION"

@interface GamePlayView : XibView

@property (strong, nonatomic) IBOutletCollection(MonsterView) NSArray *imagePlaceHolder;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *attackView;

- (void)show;
- (void)refreshGame;
@end
