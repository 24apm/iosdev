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

- (void)animatePopFrontUnit;
- (void)updateUnitViews:(NSArray *)visibleUnits;
- (void)showMessageView:(NSString *)text;
- (void)showMessageViewWithImage:(NSString *)imageName;
- (void)shakeScreen;
- (void)showPromoDialog;

@end
