//
//  GameLayoutView.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ParticleView.h"
#import "ExpUIView.h"
#import "DistanceUIView.h"
#import "UserData.h"


#define BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION @"BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION"

@interface GameLayoutView : XibView <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *fadeView;
@property (strong, nonatomic) IBOutlet UIImageView *sonicBoom;

@property (strong, nonatomic) IBOutlet ParticleView *particleView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundColorView;

@property (strong, nonatomic) IBOutlet UIButton *endGameButton;
@property (strong, nonatomic) IBOutlet UIImageView *endGameImg;
@property (strong, nonatomic) IBOutlet UIView *shopBarView;
@property (strong, nonatomic) IBOutlet UIButton *upgradeButton;
@property (strong, nonatomic) IBOutlet UIButton *achievementButton;
@property (strong, nonatomic) IBOutlet UIButton *ratingButton;
@property (strong, nonatomic) IBOutlet UIImageView *characterImageView;


- (void)generateNewGame;
+ (UIImage *)backgroundImageForTier:(BackgroundType)tier;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end
