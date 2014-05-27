//
//  GameLayoutView.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ParticleView.h"

@interface GameLayoutView : XibView <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *fadeView;
@property (strong, nonatomic) IBOutlet ParticleView *partcleView;

@property (strong, nonatomic) IBOutlet UILabel *tapPerSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *endGameButton;
@property (strong, nonatomic) IBOutlet UIImageView *endGameImg;
@property (strong, nonatomic) IBOutlet UIView *shopBarView;
@property (strong, nonatomic) IBOutlet UIButton *shopActiveButton;
@property (strong, nonatomic) IBOutlet UIButton *shopPassiveButton;
@property (strong, nonatomic) IBOutlet UIButton *shopOfflineButton;
@property (strong, nonatomic) IBOutlet UIImageView *characterImageView;

- (void)generateNewBoard;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end
