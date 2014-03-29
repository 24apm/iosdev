//
//  GameLayoutView.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "MonsterView.h"

#define NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED @"NOTIFICATION_GAME_LAYOUT_VIEW_LEFT_BUTTON_PRESSED"

#define NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED @"NOTIFICATION_GAME_LAYOUT_VIEW_RIGHT_BUTTON_PRESSED"


@interface GameLayoutView : XibView

@property (strong, nonatomic) IBOutletCollection(MonsterView) NSArray *imagePlaceHolder;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *attackView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) UIButton *currentButton;

- (void)updateUnitViews:(NSArray *)visibleUnits;
- (void)showMessageView:(NSString *)text;
- (void)showMessageViewWithImage:(NSString *)imageName;
- (void)shakeScreen;
- (void)animatePopFrontUnitFrom:(UIView *)fromView toView:(UIView *)toView;
- (void)animateOutPopFrontUnit:(NSString *)imagePath fromView:(UIView *)fromView toView:(UIView *)toView;
- (void)animateLostView;
- (void)wobbleUnits;
- (void)removeWobbleUnits;
- (MonsterView *)frontImagePlaceHolder;
- (void)flash;

@end
