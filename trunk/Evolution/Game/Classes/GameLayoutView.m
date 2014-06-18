//
//  GameLayoutView.m
//  Game
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimUtil.h"
#import "GameLayoutView.h"
#import "SoundManager.h"
#import "GameConstants.h"
#import "Utils.h"
#import "UserData.h"
#import "PromoDialogView.h"
#import "iRate.h"
#import "TrackUtils.h"
#import "CoinIAPHelper.h"
#import "ShopTableView.h"
#import "ShopManager.h"
#import "ShopRowView.h"
#import "ProgressBarComponent.h"
#import "AnimatedLabel.h"
#import "BucketView.h"
#import "BonusButton.h"
#import "UnitView.h"
#import "GameLoopTimer.h"
#import "GameManager.h"

#define TIME_BONUS_INTERVAL 60.f
#define TIME_BONUS_ACTIVED_LIMIT 5.f
#define TIME_SPAWN_GAP_WITHIN_CYCLE 1
#define TIME_SPAWN_GAP_PER_CYCLE 20
#define NUM_SPAWN 10

@interface GameLayoutView()

@property (nonatomic, retain) ShopTableView *shopTableView;
@property (nonatomic) CFTimeInterval nextSpawnTime;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) UIButton *previousSelectedButton;

@property (nonatomic, strong) NSMutableArray *units;

@end

@implementation GameLayoutView

static int promoDialogInLeaderBoardCount = 0;

- (void)createShopView {
    self.shopTableView = [[ShopTableView alloc] init];
    [self addSubview:self.shopTableView];
    [self insertSubview:self.shopBarView aboveSubview:self.shopTableView];
    
    NSArray *itemIds = [[ShopManager instance] arrayOfitemIdsFor:POWER_UP_TYPE_TAP];
    [self.shopTableView setupWithItemIds:itemIds];
    self.shopTableView.y = self.height;
}

- (IBAction)activePressed:(UIButton *)sender {
    [self showShopTableView:sender powerType:POWER_UP_TYPE_TAP];
}

- (IBAction)passivePressed:(UIButton *)sender {
    [self showShopTableView:sender powerType:POWER_UP_TYPE_PASSIVE];
}

- (IBAction)offlinePressed:(UIButton *)sender {
    [self showShopTableView:sender powerType:POWER_UP_TYPE_OFFLINE_CAP];
}
- (IBAction)iapPressed:(UIButton *)sender {
    [self showShopTableView:sender powerType:POWER_UP_TYPE_IAP];
}

- (IBAction)bucketButtonPressed:(id)sender {
    [[[BucketView alloc] init] show];
}

- (void)shopTableViewDismissed {
    self.previousSelectedButton.enabled = YES;
    self.previousSelectedButton = nil;
}

- (void)showShopTableView:(UIButton *)button powerType:(PowerUpType)type {
    self.previousSelectedButton.enabled = YES;
    self.previousSelectedButton = button;
    button.enabled = NO;
    [self.shopTableView setupWithType:type];
    [self.shopTableView show];
}

- (void)showPromoDialog {
    [TrackUtils trackAction:@"Gameplay" label:@"End"];
    promoDialogInLeaderBoardCount++;
    
    if (promoDialogInLeaderBoardCount % TIMES_PLAYED_BEFORE_PROMO == 0) {
        [PromoDialogView show];
    }
    [[iRate sharedInstance] logEvent:NO];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[UserData instance] addObserver:self forKeyPath:@"currentScore" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.backgroundView.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.backgroundView.clipsToBounds = YES;
        self.currentScoreLabel.layer.cornerRadius = 20.f * IPAD_SCALE;
        [self.progressBar fillBar:0.f];
        if (!self.shopTableView) {
            [self createShopView];
        }
        self.units = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopButtonPressed) name:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopTableViewDismissed) name:SHOP_TABLE_VIEW_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateLabelForBonus:) name:BONUS_BUTTON_TAPPED_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unitPressed:) name:UNIT_VIEW_TAPPED object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawStep) name:DRAW_STEP_NOTIFICATION object:nil];
        self.currentScoreLabel.text = [[GameManager instance] scoreString];
        self.levelLabel.text = [NSString stringWithFormat:@"%d", [[GameManager instance] currentLevel]];

    }
    return self;
}

- (void)drawStep {
    if (CACurrentMediaTime() > self.nextSpawnTime) {
        if (self.units.count < NUM_SPAWN) {
            [self generateUnit];
            self.nextSpawnTime = CACurrentMediaTime() + TIME_SPAWN_GAP_WITHIN_CYCLE;
        }
    }
    
    for (UnitView *unit in self.units) {
        [unit step];
    }
    [self.characterView step];
}

- (void)unitPressed:(NSNotification *)notification {
    UnitView *unit = notification.object;
    
    CGPoint center = [unit.superview convertPoint:unit.center toView:self.characterView.superview];
    self.characterView.state = UnitViewStateAnimateAttacking;
    
    if (center.x > self.characterView.center.x) {
        self.characterView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    } else {
        self.characterView.transform = CGAffineTransformMakeScale(-1.f, 1.f);
    }
    
    CGPoint overShootCenter = CGPointMake((center.x - self.characterView.center.x) * 0.1f + center.x,
                                          (center.y - self.characterView.center.y) * 0.1f + center.y);
    
    [UIView animateWithDuration:0.05f animations:^ {
        self.characterView.center = overShootCenter;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.1f animations:^ {
            self.characterView.center = center;
        } completion:^(BOOL completed) {
            if (unit.state == UnitViewStateDeath) {
                if (self.units.count >= NUM_SPAWN) {
                    self.nextSpawnTime = CACurrentMediaTime() + TIME_SPAWN_GAP_PER_CYCLE;
                }
                [self.units removeObject:unit];
                [unit removeFromSuperview];
                [[GameManager instance] addScore:unit.value];
                self.currentScoreLabel.text = [[GameManager instance] scoreString];
                self.levelLabel.text = [NSString stringWithFormat:@"%d", [[GameManager instance] currentLevel]];

                [[SoundManager instance] play:SOUND_EFFECT_BUI];
            } else {
                [self shakeScreen];
                [[SoundManager instance] play:SOUND_EFFECT_SHARP_PUNCH];
                unit.state = UnitViewStateDeath;
            }
        }];
    }];
    
}

- (void)generateUnits {
    while (self.units.count < 10) {
        [self generateUnit];
    }
}

- (void)generateUnit {
    float randX = arc4random() % (int)self.environmentView.width;
    float randY = arc4random() % (int)self.environmentView.height;
    
       
    UnitView *unit = [[UnitView alloc] init];
    [self.environmentView addSubview:unit];
    [self.units addObject:unit];
    unit.center = CGPointMake(randX, randY);
    [unit generateTarget];
}

- (void)shopButtonPressed {
    [self.shopTableView refresh];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScore"])
    {
        u_int value = [[change objectForKey:NSKeyValueChangeNewKey]intValue];
        self.currentScoreLabel.text = [NSString stringWithFormat:@"$%@", [Utils formatWithComma:value]];
    }
}

- (void)generateNewBoard {
    [self generateUnits];
    [[UserData instance] updateOfflineTime];
}

- (void)removeAnimation:(UIView *)view {
    [view removeFromSuperview];
}

- (void)shakeScreen {
    [AnimUtil wobble:self duration:0.1f angle:M_PI/128.f repeatCount:1];
}

- (void)animateLabelForBonus:(NSNotification *)notification {
    BonusButton *button = notification.object;
    [UserData instance].currentScore += button.currentRewardPoints;
    
    CGPoint point = [button.superview convertPoint:button.center toView:self];
    
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%.1f", button.currentRewardPoints];
    label.label.textColor = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    label.center = point;
    [label animate];
}

@end
