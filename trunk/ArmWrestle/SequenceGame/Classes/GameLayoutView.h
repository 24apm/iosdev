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

#define NOTIFICATION_GAME_INTRO_SKIPPED @"NOTIFICATION_GAME_INTRO_SKIPPED"


@interface GameLayoutView : XibView
@property (strong, nonatomic) IBOutlet UIImageView *cloud;
@property (strong, nonatomic) IBOutlet UIImageView *door;
@property (strong, nonatomic) IBOutlet UIImageView *person;
@property (strong, nonatomic) IBOutlet UIImageView *female;
@property (strong, nonatomic) IBOutlet UIImageView *male;
@property (strong, nonatomic) IBOutlet UIView *finalPoint;
@property (strong, nonatomic) IBOutlet UIImageView *doorAfter;

@property (strong, nonatomic) IBOutlet UILabel *timeText;
@property (strong, nonatomic) IBOutletCollection(MonsterView) NSArray *imagePlaceHolder;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *attackView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) UIButton *currentButton;
@property (strong, nonatomic) IBOutlet UIView *introView;
@property (strong, nonatomic) IBOutlet UIView *handView1;
@property (strong, nonatomic) IBOutlet UIView *handView2;
@property (strong, nonatomic) IBOutlet UIImageView *introMale;
@property (strong, nonatomic) IBOutlet UIImageView *introFemale;
@property (strong, nonatomic) IBOutlet UIImageView *introOpenDoor;
@property (strong, nonatomic) IBOutlet UIImageView *introPerson;
@property (strong, nonatomic) IBOutlet UIImageView *introCloseDoor;
@property (strong, nonatomic) IBOutlet UIImageView *introBackground;
@property (strong, nonatomic) IBOutlet UIImageView *doorClose;
@property (nonatomic) int delay;

- (void)gameplayEnd;
- (void)introduction;
- (void)handShow;
- (void)updateUnitViews:(NSArray *)visibleUnits;
- (void)showMessageView:(NSString *)text;
- (void)showMessageViewWithImage:(NSString *)imageName;
- (void)shakeScreen;
- (void)animateUnitFrom:(UIView *)fromView toView:(UIView *)toView;
- (void)animateLostView;
- (void)wobbleUnits;
- (void)removeWobbleUnits;
- (MonsterView *)frontImagePlaceHolder;
- (void)flash;
- (void)animateMovingToDoorFor:(UIView *)view;
- (void)roundStart;
- (void)setupDefault;
- (void)restoreDefault;
- (void)animateMovingAwayfromDoorFor:(UIView *)view;
@end
