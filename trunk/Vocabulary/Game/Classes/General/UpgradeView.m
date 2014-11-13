//
//  UpgradeView.m
//  Make It Flappy
//
//  Created by MacCoder on 6/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UpgradeView.h"
#import "AnimatedLabel.h"
#import "GameConstants.h"
#import "TrackUtils.h"
@interface UpgradeView ()

@property (nonatomic, strong) NSString *stateNotification;
@property (nonatomic, strong) BLOCK block;
@end

@implementation UpgradeView


- (id)initWithBlock:(BLOCK)block; {
    self = [super init];
    if (self) {
        self.block = block;
        }
    return self;
}

- (IBAction)LvlButtonPressed:(id)sender {
    if (YES || [UserData instance].coin >= self.cost) {
        //[[UserData instance] decrementCoin:self.cost];
        self.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:self.stateNotification object:nil];
        [self animateLabelWithStringRedCenter:[NSString stringWithFormat:@"-%lld", self.cost]];
        [self performSelector:@selector(dismissed:) withObject:nil afterDelay:1.f];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:BUY_COIN_VIEW_NOTIFICATION object:nil];
    }
}

- (IBAction)buyCoinButtonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:BUY_COIN_VIEW_NOTIFICATION object:nil];
}

- (void)show {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:BUY_COIN_VIEW_DISMISS_NOTIFICATION  object:nil];
    [super show];
    [self refresh];
}

- (void)showForAnswer {
    self.cost = 50;
    self.lvlLabel.text = @"Show Answer for:";
    self.stateNotification = UNLOCK_ANSWER_NOTIFICATION;
    [self show];
}

- (void)showForKey {
    self.cost = 10;
    self.lvlLabel.text = @"Refill all Keys for:";
    self.stateNotification = ADD_KEY_NOTIFICATION;
    [self show];
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self activateBlock];
    [self dismissed:self];
}

- (void)activateBlock {
    if (self.block != nil) {
        self.block();
    }
}

- (void)refresh {
    self.currentExpLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:[UserData instance].coin]];
    self.nextCostLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:self.cost]];
    long long tempResult = [UserData instance].coin;
    tempResult -= self.cost;
    self.afterCostLabel.text = [NSString stringWithFormat:@"%@",[Utils formatLongLongWithComma:tempResult]];
}

- (void)animateLabelWithStringGreenCenter:(NSString *)string {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.text = string;
    label.label.textColor = [UIColor colorWithRed:0.f green:1.f blue:0.f alpha:1.f];
    label.label.font = [label.label.font fontWithSize:100];
    float midX = self.center.x;
    float midY = self.center.y - (80 * IPAD_SCALE);
    label.center = CGPointMake(midX, midY);
    [label animateSlow];
}

- (void)animateLabelWithStringRedCenter:(NSString *)string {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.text = string;
    label.label.textColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f];
    label.label.font = [label.label.font fontWithSize:100];
    float midX = self.center.x;
    float midY = self.center.y *(IPAD_SCALE);
    label.center = CGPointMake(midX, midY);
    [label animate];
}
@end
