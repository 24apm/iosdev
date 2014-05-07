//
//  GameLayoutView.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "BoardView.h"
#import "ButtonView.h"
#import "PurchaseManager.h"
#import "ConfirmMenu.h"
#import "CoinMenuView.h"
#import "AnimatedLabel.h"

@interface GameLayoutView : XibView <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *fadeView;
@property (strong, nonatomic) IBOutlet UIButton *buyCoinButton;

@property (strong, nonatomic) IBOutlet BoardView *boardView;
@property (strong, nonatomic) IBOutlet UILabel *currentScore;
@property (strong, nonatomic) IBOutlet UIButton *endGameButton;
@property (strong, nonatomic) IBOutlet UILabel *coinLabel;
@property (strong, nonatomic) IBOutlet UIImageView *endGameImg;
@property (strong, nonatomic) IBOutlet ButtonView *buttonView1;
@property (strong, nonatomic) IBOutlet ButtonView *buttonView2;
@property (strong, nonatomic) IBOutlet ButtonView *buttonView3;

@property (strong, nonatomic) IBOutlet ButtonView *lostButtonView1;
@property (strong, nonatomic) IBOutlet ButtonView *lostButtonView2;
@property (strong, nonatomic) IBOutlet ButtonView *lostButtonView3;

@property (strong, nonatomic) IBOutlet ConfirmMenu *confirmMenu;
@property (strong, nonatomic) IBOutlet UIView *coinContainer;

@property (strong, nonatomic) ButtonView *queuedPowerUp;

- (void)generateNewBoard;

@end
