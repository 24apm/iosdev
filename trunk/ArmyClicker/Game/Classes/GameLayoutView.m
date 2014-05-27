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
#import "CoinMenuView.h"

#define TIME_BONUS_INTERVAL 60.f
#define TIME_BONUS_ACTIVED_LIMIT 5.f

@interface GameLayoutView()

@property (nonatomic, retain) ShopTableView *shopTableView;

@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) UIButton *previousSelectedButton;

@property (nonatomic) double startTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerForBonus;
@property (nonatomic, strong)NSMutableArray * tapTotal;
@property (nonatomic, strong)NSMutableArray * tapTotalPoints;
@property (nonatomic) double displayTPS;
@property (nonatomic) double oldDisplayTPS;
@property (nonatomic) double tapBonus;
@property (nonatomic) double timeBonus;
@property (nonatomic) double tapsPerSecond;
@property (nonatomic) double tapsPerSecondPoints;
@property (nonatomic) double scorePerTap;
@property (nonatomic) double totalScorePerTap;
@property (nonatomic) double timeBonusEnd;
@property (nonatomic) BOOL timeBonusOn;
@property (nonatomic) double deleteTime;
@property (nonatomic) BOOL doDecay;
@property (nonatomic) double previousTime;
@property (nonatomic) double delay;
@property (nonatomic) double tempPassiveLabel;
@property (nonatomic) int ticks;
@property (nonatomic, strong) BucketView* bucketView;
@property (nonatomic) double displayAverageTPS;
@property (nonatomic) int tapBonusLevel;
@property (nonatomic, strong) NSMutableArray *bonusArray;
@property (nonatomic) BOOL bonusTapOn;
@property (nonatomic) double bonusStartTime;


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
        self.tapTotal = [NSMutableArray array];
        self.tapTotalPoints = [NSMutableArray array];
        self.bonusArray = [NSMutableArray array];
        self.displayTPS = [[UserData instance] totalPointForPassive];
        self.tapPerSecondLabel.text = [self timePerSec:self.displayTPS];
        self.scorePerTap = 1;
        self.tapBonus = 0;
        self.previousTime = CURRENT_TIME;
        self.doDecay = NO;
        self.tapsPerSecond = 0;
        self.tapBonusLevel = 1;
        [self.progressBar fillBar:0.f];
        self.tapsPerSecondPoints = 0;
        self.tempPassiveLabel = [UserData instance].currentScore;
        if (!self.shopTableView) {
            [self createShopView];
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopButtonPressed) name:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopTableViewDismissed) name:SHOP_TABLE_VIEW_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateLabelForBonus:) name:BONUS_BUTTON_TAPPED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyPowerUp:) name:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:nil];
        
    }
    return self;
}

- (void)shopButtonPressed {
    [self.shopTableView refresh];
    [self updateTPS];
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f/UPDATE_TIME_PER_TICK target:self selector:@selector(update) userInfo:nil repeats:YES];
    self.startTime = [UserData instance].startTime;
    self.timeBonus = [UserData instance].startTime;
    [[UserData instance] updateOfflineTime];
    [self checkIfSavedTimePassedTimeBonus];
    
}

- (IBAction)tapPressedDown:(id)sender {
    self.characterImageView.transform = CGAffineTransformMakeScale(1.02f, 1.02f);
}


- (IBAction)tapPressed:(id)sender {
    if ([self tapTotalAverage:self.tapTotal] <= 0) {
        [self.tapTotal removeAllObjects];
    }
    float currentTap = (float)([[UserData instance] totalPointPerTap:self.timeBonusOn] * ((float)self.tapBonusLevel));
    [[UserData instance]addScore:currentTap];
    [self updateTPSWithTap:currentTap];
    self.tapBonus++;
    self.tapsPerSecond++;
    [self animateLabel:currentTap];
    
    self.characterImageView.transform = CGAffineTransformIdentity;
}


- (void)animateLabel:(int)value {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.characterImageView addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%d", value];
    float marginPercentage = 0.5f;
    float randX = arc4random() % (int)self.characterImageView.width * marginPercentage + self.characterImageView.width * marginPercentage / 2.f;
    float randY = arc4random() % (int)self.characterImageView.height * marginPercentage + self.characterImageView.height * marginPercentage / 2.f;
    label.center = CGPointMake(randX, randY);
    [label animate];
}

- (NSString *)characterImageTier:(int)tier {
    return [NSString stringWithFormat:@"clicker_character%d.png", tier];
}

- (void)updateTPSWithTap:(float)number {
    self.tapsPerSecondPoints += number;
    [self updateTPS];
}

- (void)updateTPS {
    self.displayTPS = self.tapsPerSecondPoints + [[UserData instance] totalPointForPassive];
    if (self.tapTotal.count <= 0) {
        self.tapPerSecondLabel.text = [self timePerSec:self.displayTPS];
    }
}

- (void)updateAverageTPS {
    double average = [self tapTotalAverage:self.tapTotalPoints];
    if (average <= 0) {
        average = 0;
    }
    self.displayAverageTPS = average + [[UserData instance] totalPointForPassive];
    self.tapPerSecondLabel.text = [self timePerSec:self.displayAverageTPS];
}

- (NSString *)timePerSec:(double)sec {
    return [NSString stringWithFormat:@"$%.1f/sec", sec];
}

- (void)checkIfSavedTimePassedTimeBonus {
    double time = CURRENT_TIME;
    if (time - self.timeBonus > TIME_BONUS_INTERVAL) {
        self.timeBonus = time;
        [[UserData instance] saveUserStartTime:time];
    } else {
        double percentage = (time - self.timeBonus) / TIME_BONUS_INTERVAL;
        [self.progressBar fillBar:percentage];
    }
}

- (float)tapTotalCombined {
    float temp = 0;
    for (int i = 0; i < self.tapTotal.count; i++) {
        temp  = temp + [[self.tapTotal objectAtIndex:i]floatValue];
    }
    return temp;
}

- (void)update {
    double time = CURRENT_TIME;
    self.tempPassiveLabel = [[UserData instance] currentScore];
    self.tempPassiveLabel += [[UserData instance] totalPointForPassive] / UPDATE_TIME_PER_TICK;
    [[UserData instance] addScoreByPassive];
    double gapTime = time - self.previousTime;
    [[UserData instance] updateOfflineTime];
    if (gapTime >= 1) {
        
        [[UserData instance] saveUserCoin];
        self.previousTime = time;
        
        if (self.tapTotal.count > 0) {
            [self.tapTotal addObject:[NSNumber numberWithFloat:self.tapsPerSecond]];
            [self.tapTotalPoints addObject:[NSNumber numberWithFloat:self.tapsPerSecondPoints]];
        }
        
        if (self.tapsPerSecond > 0 && self.tapTotal.count <= 0) {
            [self.tapTotal addObject:[NSNumber numberWithFloat:self.tapsPerSecond]];
            [self.tapTotalPoints addObject:[NSNumber numberWithFloat:self.tapsPerSecondPoints]];
        }
        
        if (self.tapTotal.count > 2) {
            [self.tapTotal removeObjectAtIndex:0];
            [self.tapTotalPoints removeObjectAtIndex:0];
        }
        
       // [self levelOfTapBonus];
        
        if ([self tapTotalAverage:self.tapTotal] <= 0) {
            [self.tapTotal removeAllObjects];
            [self.tapTotalPoints removeAllObjects];
        }
        
        self.tapsPerSecond = 0;
        self.tapsPerSecondPoints = 0;
        
        [self updateAverageTPS];
    }
    
    if (self.tapBonus >= 15) {
        [self tapBonusActivate];
    }
    
    if (self.bonusTapOn) {
        self.bonusStartTime = CURRENT_TIME;
        if(!self.timerForBonus){
            self.timerForBonus = [NSTimer scheduledTimerWithTimeInterval:1.f/UPDATE_TIME_PER_TICK_FOR_BONUS target:self selector:@selector(updateForBonus) userInfo:nil repeats:YES];
        }
        self.bonusTapOn = NO;
    }
    
    if (!self.timeBonusOn) {
        double percentage = (time - self.timeBonus) / TIME_BONUS_INTERVAL;
        [self.progressBar fillBar:percentage];
    }
    
    if (!self.timeBonusOn && time - self.timeBonus > TIME_BONUS_INTERVAL) {
        [self timeBonusActivate];
        [self.progressBar fillBar:1.f];
    }
    
    if (self.timeBonusOn && time - self.timeBonusEnd > 5) {
        [self timeBonusDeactivate];
        [self.progressBar fillBar:0.f];
    }
}

- (void)levelOfTapBonus {
    
    float currentTap = [self tapTotalAverage:self.tapTotal];
    int birthRate;
    if ( currentTap >= 12) {
        
        self.tapBonusLevel = 6;
        birthRate = 6;
        
    } else if (currentTap >= 11) {
        
        self.tapBonusLevel = 5;
        birthRate = 5;
        
    } else if (currentTap >= 10) {
        
        self.tapBonusLevel = 4;
        birthRate = 4;
        
    } else if (currentTap >= 8) {
        
        self.tapBonusLevel = 3;
        birthRate = 3;
        
    } else if (currentTap >= 5) {
        
        self.tapBonusLevel = 2;
        birthRate = 1;
        
    } else {
        
        self.tapBonusLevel = 1;
        birthRate = 0;
        
    }
    
    [self.partcleView updateBirthRate:birthRate];
    
    int index = self.tapBonusLevel > 4 ? 4 : self.tapBonusLevel;
    self.characterImageView.image = [UIImage imageNamed:[self characterImageTier:index]];
}

- (void)updateForBonus {
    for (int i = 0; i < self.bonusArray.count; i++) {
        ((BonusButton *)[self.bonusArray objectAtIndex:i]).x += 3.f;
        ((BonusButton *)[self.bonusArray objectAtIndex:i]).y += 0.5f;
    }
    if (CURRENT_TIME - self.bonusStartTime > 5) {
        [self.timerForBonus invalidate], self.timerForBonus = nil;
        [self.bonusArray removeAllObjects];
    }
    
}

- (float)tapTotalAverage:(NSMutableArray *)array {
    float totalAverage = 0;
    for (int i = 0; i < array.count; i++) {
        totalAverage = totalAverage + [[array objectAtIndex:i] floatValue];
    }
    
    float temp = totalAverage;
    
    if (array.count > 0) {
        temp = temp/array.count;
    }
    return temp;
}

- (void)startPointDisplacment:(UIView *)view {
    float x = [Utils randBetweenMin:10.f max:self.bounds.size.width];
    x = x * -1;
    view.x = x;
    
    float y = [Utils randBetweenMin:1.f max:(self.bounds.size.height/3) + 50];
    view.y = y;
    
}
- (void)tapBonusActivate {
    
    //[self animateArc];
    for (int i = 0; i < 10; i++) {
        BonusButton *bonus = [[BonusButton alloc]init];
        [self startPointDisplacment:bonus];
        [self.bonusArray addObject:bonus];
        [self addSubview:bonus];
    }
    self.tapBonus = 0;
    self.bonusTapOn = YES;
    NSLog(@"BONUS");
}

- (void)removeAnimation:(UIView *)view {
    [view removeFromSuperview];
}

- (void)animateArc
{
    // Create the arc
    CGPoint arcStart = CGPointMake(0.2 * self.bounds.size.width, 0.5 * self.bounds.size.height);
    CGPoint arcCenter = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
    CGFloat arcRadius = 0.3 * MIN(self.bounds.size.width, self.bounds.size.height);
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathMoveToPoint(arcPath, NULL, arcStart.x, arcStart.y);
    CGPathAddArc(arcPath, NULL, arcCenter.x, arcCenter.y, arcRadius, M_PI, 0, NO);
    
    BonusButton *bonus = [[BonusButton alloc]init];
    [self addSubview: bonus];
    bonus.center = arcStart;
    
    
    // The animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.duration = 2.0;
    pathAnimation.path = arcPath;
    CGPathRelease(arcPath);
    
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    [bonus.layer addAnimation:pathAnimation forKey:@"arc"];
    
    [self performSelector:@selector(removeAnimation:) withObject:bonus afterDelay:20.f];
}

- (void)timeBonusActivate {
    self.timeBonusEnd = CURRENT_TIME + TIME_BONUS_ACTIVED_LIMIT;
    self.timeBonusOn = YES;
    NSLog(@"TIME");
}

- (void)timeBonusDeactivate {
    double time = CURRENT_TIME;
    self.timeBonus = time;
    [[UserData instance] saveUserStartTime:time];
    self.timeBonusOn = NO;
    NSLog(@"TIME END");
}

- (void)shakeScreen {
    [AnimUtil wobble:self duration:0.1f angle:M_PI/128.f repeatCount:2];
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

- (void)applyPowerUp:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    
    if ([productIdentifier isEqualToString:POWER_UP_IAP_FUND]) {
        [UserData instance].currentScore += 100000;
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_DOUBLE]) {
        [UserData instance].currentScore = [UserData instance].currentScore * 2;
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_QUADPLE]) {
        [UserData instance].currentScore = [UserData instance].currentScore * 4;
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_SUPER]) {
        [UserData instance].currentScore = [UserData instance].currentScore * 100;
        
    }
    [[UserData instance] saveUserCoin];
    
}

@end
