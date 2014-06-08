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
#import "ErrorDialogView.h"

#define TIME_BONUS_INTERVAL 300.f
#define TIME_BONUS_ACTIVED_LIMIT 5.f
#define MAX_TAP_FOR_BONUS 500.f
#define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)

@interface GameLayoutView()

@property (nonatomic, retain) ShopTableView *shopTableView;

@property (strong, nonatomic) IBOutlet UIImageView *shinyBackground;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) UIButton *previousSelectedButton;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBarTaps;

@property (nonatomic) double startTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerForBonus;
@property (nonatomic, strong)NSMutableArray * tapTotal;
@property (nonatomic, strong)NSMutableArray * tapTotalPoints;
@property (nonatomic) double displayTPS;
@property (nonatomic) int currentIndexForImage;
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
@property (nonatomic) int lastColorIndex;

@property (nonatomic, strong) NSMutableArray *bonusArray;
@property (nonatomic) BOOL bonusTapOn;
@property (nonatomic) double bonusStartTime;
@property (strong, nonatomic) IBOutlet UIView *iapOverlay;
@property (nonatomic) double maxTapScore;


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
    [self shopTableAlphaTo:1.f];
    [self showShopTableView:sender powerType:POWER_UP_TYPE_TAP];
}

- (IBAction)passivePressed:(UIButton *)sender {
    [self shopTableAlphaTo:1.f];
    [self showShopTableView:sender powerType:POWER_UP_TYPE_PASSIVE];
}

- (IBAction)offlinePressed:(UIButton *)sender {
    [self shopTableAlphaTo:1.f];
    [self showShopTableView:sender powerType:POWER_UP_TYPE_OFFLINE_CAP];
}
- (IBAction)iapPressed:(UIButton *)sender {
    [self shopTableAlphaTo:1.f];
    if ([CoinIAPHelper sharedInstance].hasLoaded) {
        [self showShopTableView:sender powerType:POWER_UP_TYPE_IAP];
    } else {
        [[[ErrorDialogView alloc] init] show];
    }
}

- (IBAction)bucketButtonPressed:(id)sender {
    [[[BucketView alloc] init] show];
}

- (void)shopTableViewDismissed {
    [self shopTableAlphaTo:0.5f];
    self.previousSelectedButton.enabled = YES;
    self.previousSelectedButton = nil;
}

- (void)shopTableAlphaTo:(float)alpha {
    self.shopBarView.backgroundColor = [UIColor colorWithRed:37.f/255.f green:128.f/255.f blue:60.f/255.f alpha:alpha];
}

- (void)showShopTableView:(UIButton *)button powerType:(PowerUpType)type {
    self.previousSelectedButton.enabled = YES;
    self.previousSelectedButton = button;
    button.enabled = NO;
    [self.shopTableView setupWithType:type];
    [self.shopTableView show];
}

- (void)showPromoDialog {
    [TrackUtils trackAction:@"PromoShow" label:@"End"];
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
        self.backgroundColorView.image = [self colorForTier:1];
        self.currentScoreLabel.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.tapTotal = [NSMutableArray array];
        self.tapTotalPoints = [NSMutableArray array];
        self.currentIndexForImage = 1;
        self.bonusArray = [NSMutableArray array];
        self.displayTPS = [[UserData instance] totalPointForPassive];
        self.tapPerSecondLabel.text = [self timePerSec:self.displayTPS];
        self.scorePerTap = 1;
        self.tapBonus = 0;
        self.lastColorIndex = -1;
        [self shopTableAlphaTo:0.5f];
        self.previousTime = CURRENT_TIME;
        self.doDecay = NO;
        self.tapsPerSecond = 0;
        self.tapBonusLevel = 1;
        [self.progressBar fillBar:0.f];
        self.tapsPerSecondPoints = 0;
        self.iapOverlay.hidden = NO;
        [self.progressBarTaps fillBar:0.f];
        self.shinyBackground.hidden = YES;
        self.tempPassiveLabel = [UserData instance].currentScore;
        if (!self.shopTableView) {
            [self createShopView];
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopButtonPressed:) name:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopTableViewDismissed) name:SHOP_TABLE_VIEW_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateLabelForBonus:) name:BONUS_BUTTON_TAPPED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyPowerUp:) name:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyingProduct:) name:IAP_ITEM_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openIAPOverlay) name:IAP_ITEM_LOADED_NOTIFICATION object:nil];
    }
    return self;
}


- (void)shopButtonPressed:(NSNotification*)notification {
    ShopRowView *item = notification.object;
    [self animateLabelForShopRow:item];
    self.shopBarView.alpha = 1.f;
    [self.shopTableView refresh];
    [self updateTPS];
}

- (void)animateLabelForShopRow:(ShopRowView*)item {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    CGPoint point = [item.superview convertPoint:item.center toView:self];
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    label.label.text = [NSString stringWithFormat:@"-%lld", item.cost];
    label.center = point;
    [label animate];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScore"])
    {
        long long value = [[change objectForKey:NSKeyValueChangeNewKey]longLongValue];
        self.currentScoreLabel.text = [NSString stringWithFormat:@"$%@", [Utils formatLongLongWithComma:value]];
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
    long long currentTap =([[UserData instance] totalPointPerTap:self.timeBonusOn] * ((float)self.tapBonusLevel));
    [[UserData instance]addScore:currentTap];
    [self updateTPSWithTap:currentTap];
    
    self.tapBonus++;
    self.tapsPerSecond++;

    [self animateLabel:currentTap];
    [[SoundManager instance]play:SOUND_EFFECT_GUINEA];
    self.characterImageView.transform = CGAffineTransformIdentity;
}


- (void)animateLabel:(long long)value {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.characterImageView addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%lld", value];
    float marginPercentage = 0.5f;
    float randX = arc4random() % (int)self.characterImageView.width * marginPercentage + self.characterImageView.width * marginPercentage / 2.f;
    float randY = arc4random() % (int)self.characterImageView.height * marginPercentage + self.characterImageView.height * marginPercentage / 2.f;
    label.center = CGPointMake(randX, randY);
    [label animate];
}

- (void)animateLabelWithString:(NSString *)string {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.characterImageView addSubview:label];
    label.label.text = string;
    label.label.textColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f];
    label.label.font = [label.label.font fontWithSize:60];
    float midX = self.characterImageView.center.x;
    float midY = self.characterImageView.center.y - (80 * IPAD_SCALE);
    label.center = CGPointMake(midX, midY);
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
    return [NSString stringWithFormat:@"$%.f/sec", sec];
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

- (UIImage *)colorForTier:(int)tier {
    switch (tier) {
        case 1:
            return [UIImage imageNamed:@"background_tier1"];
            break;
        case 2:
            return [UIImage imageNamed:@"background_tier2"];
            break;
        case 3:
            return [UIImage imageNamed:@"background_tier3"];
            break;
        case 4:
            return [UIImage imageNamed:@"background_tier4"];
            break;
        case 5:
            return [UIImage imageNamed:@"background_tier5"];
            break;
        case 6:
            return [UIImage imageNamed:@"background_tier6"];
            break;
        default:
            return nil;
            break;
    }
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
        
        if (self.tapsPerSecondPoints > 0) {
            if (self.maxTapScore < self.tapsPerSecondPoints + [[UserData instance] totalPointForPassive]) {
                self.maxTapScore = self.tapsPerSecondPoints + [[UserData instance] totalPointForPassive];
                if (self.maxTapScore > [UserData instance].currentMaxTapPerSecond) {
                    [[UserData instance] saveUserCurrentMaxTap:self.maxTapScore];
                }
            }
        }
        
        if (self.tapTotal.count > 0) {
            [self.tapTotal addObject:[NSNumber numberWithFloat:self.tapsPerSecond]];
            [self.tapTotalPoints addObject:[NSNumber numberWithFloat:self.tapsPerSecondPoints]];

        } else if (self.tapTotal.count <= 0 && self.tapsPerSecond > 0) {
            [self.tapTotal addObject:[NSNumber numberWithFloat:self.tapsPerSecond]];
            [self.tapTotalPoints addObject:[NSNumber numberWithFloat:self.tapsPerSecondPoints]];

        } else {
        }
        
        if (self.tapTotal.count > 2) {
            [self.tapTotal removeObjectAtIndex:0];
            [self.tapTotalPoints removeObjectAtIndex:0];
        }
        
        [self levelOfTapBonus];

        if ([self tapTotalAverage:self.tapTotal] <= 0) {
            [self.tapTotal removeAllObjects];
            [self.tapTotalPoints removeAllObjects];
        }

        self.tapsPerSecond = 0;
        self.tapsPerSecondPoints = 0;
        
        [self updateAverageTPS];
    }
    
    [self updateTapBar];
    
    if (self.tapBonus >= MAX_TAP_FOR_BONUS) {
        [self tapBonusActivate];
        [self.progressBarTaps fillBar:0.f];
    }
    
    if (self.bonusTapOn) {
        //        if(!self.timerForBonus){
        //            self.timerForBonus = [NSTimer scheduledTimerWithTimeInterval:1.f/UPDATE_TIME_PER_TICK_FOR_BONUS target:self selector:@selector(updateForBonus) userInfo:nil repeats:YES];
        //        }
        [[SoundManager instance]play:SOUND_EFFECT_BLING];
        [self generateBonus];
        self.bonusTapOn = NO;
    }
    
    if (!self.timeBonusOn) {
        double percentage = (time - self.timeBonus) / TIME_BONUS_INTERVAL;
        [self.progressBar fillBar:percentage];
    }
    
    if (!self.timeBonusOn && time - self.timeBonus > TIME_BONUS_INTERVAL) {
        [self timeBonusActivate];
        [[SoundManager instance] play:SOUND_EFFECT_HALLELUJAH];

        [self animateRotation:self.shinyBackground];
        
        self.shinyBackground.hidden = NO;
        [self.progressBar fillBar:1.f];
    }
    
    if (self.timeBonusOn && time - self.timeBonusEnd > 5) {
        [self timeBonusDeactivate];
        self.shinyBackground.hidden = YES;
        [self showPromoDialog];
        [self.progressBar fillBar:0.f];
    }
}

- (void)animateRotation:(UIView *)view {
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.duration = 15.0f;
    anim.autoreverses = NO;
    anim.repeatCount = HUGE_VALF;
    anim.fromValue = @(0.f);
    anim.toValue = @(M_PI * 2.0f);
    [view.layer addAnimation:anim forKey:@"my_rotation"];
}

#pragma helperFunction

- (void)updateTapBar {
    float percentage = self.tapBonus / MAX_TAP_FOR_BONUS;
    [self.progressBarTaps fillBar:percentage];
}

- (void)levelOfTapBonus {
    
    float currentTap = [self tapTotalAverage:self.tapTotal];
    
    if ( currentTap >= 12) {
        
        self.tapBonusLevel = 6;
        
    } else if (currentTap >= 10) {
        
        self.tapBonusLevel = 5;
        
    } else if (currentTap >= 8) {
        
        self.tapBonusLevel = 4;
        
    } else if (currentTap >= 7) {
        
        self.tapBonusLevel = 3;
        
    } else if (currentTap >= 5) {
        
        self.tapBonusLevel = 2;
        
    } else {
        
        self.tapBonusLevel = 1;
        
    }
    
    
    if (self.lastColorIndex != self.tapBonusLevel) {
        self.lastColorIndex = self.tapBonusLevel;
        UIImage *bgColorImage = [self colorForTier:self.lastColorIndex];
        [UIView animateWithDuration:0.5f
                         animations:^ {
                             self.backgroundColorView.image = bgColorImage;
                         }];
    }
    
    if (self.currentIndexForImage != self.tapBonusLevel) {
        self.currentIndexForImage = self.tapBonusLevel;
        self.characterImageView.image = [UIImage imageNamed:[self characterImageTier:self.currentIndexForImage]];
    }
}

- (void)generateBonus {
    for (int i = 0; i < self.bonusArray.count; i++) {
        BonusButton *button = [self.bonusArray objectAtIndex:i];
        
        CGPoint startPoint = self.center;
        CGPoint endPoint = [self randomPoint];
        CGPoint controlPoint = CGPointMake(self.center.x, 0);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
        
        CGPathAddQuadCurveToPoint(path, NULL,
                                  controlPoint.x, controlPoint.y,
                                  endPoint.x, endPoint.y);
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        anim.path = path;
        anim.duration = 1.f;
        anim.keyTimes = @[@(0.0),@(0.3),@(0.9)];
        [button.layer addAnimation:anim forKey:@"animation"];
        button.center = endPoint;
        
        [self performSelector:@selector(animateButtonOut:) withObject:button afterDelay:anim.duration + 0.5f];
    }
}

- (void)animateButtonOut:(UIView *)view {
    [UIView animateWithDuration:0.5f animations:^ {
        view.center = CGPointMake(view.center.x, view.center.y - view.height);
        view.alpha = 0.f;
    } completion: ^(BOOL completed) {
        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.f];
    }];
    
}

- (void)updateForBonus {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < self.bonusArray.count; i++) {
        BonusButton *button = [self.bonusArray objectAtIndex:i];
        CGAffineTransform rotation = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(180));
        [UIView animateWithDuration:3.f animations:^{
            // button.transform = CGAffineTransformMakeScale(0, 0);
            button.transform = rotation;
        } completion:^(BOOL complete) {
            [temp addObject:button];
        }];
    }
    self.bonusArray = temp;
    if (self.bonusArray <= 0) {
        [self.timerForBonus invalidate], self.timerForBonus = nil;
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

- (CGPoint)randomPoint {
    float x = [Utils randBetweenMin:25.f * IPAD_SCALE max:self.bounds.size.width - 25.f];
    float y = [Utils randBetweenMin:80.f * IPAD_SCALE max:(self.bounds.size.height/3 * 2)];
    return CGPointMake(x, y);
}
- (void)tapBonusActivate {
    
    //[self animateArc];
    for (int i = 0; i < 5; i++) {
        BonusButton *bonus = [[BonusButton alloc]init];
        bonus.center = [self randomPoint];
        [self.bonusArray addObject:bonus];
        [self insertSubview:bonus belowSubview:self.shopTableView];
    }
    self.tapBonus = 0;
    self.bonusTapOn = YES;
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
    [self animateLabelWithString:@"X10"];
    self.timeBonusOn = YES;
}

- (void)timeBonusDeactivate {
    double time = CURRENT_TIME;
    self.timeBonus = time;
    [[UserData instance] saveUserStartTime:time];
    self.timeBonusOn = NO;
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
    label.label.text = [NSString stringWithFormat:@"+%.f", button.currentRewardPoints];
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


- (void)buyingProduct:(NSNotification *)notification {
    self.userInteractionEnabled = NO;
    [TrackUtils trackAction:@"buyingProduct" label:@""];
    ShopRowView *rowItem = notification.object;
    [[CoinIAPHelper sharedInstance] buyProduct:rowItem.product];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    if (productIdentifier) {
        self.userInteractionEnabled = YES;
        [TrackUtils trackAction:@"buyingProductSuccess" label:@""];
        [[NSNotificationCenter defaultCenter]postNotificationName:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:productIdentifier];
    }
}

- (void)productFailed:(NSNotification *)notification {
    [TrackUtils trackAction:@"buyingProductFail" label:@""];
    self.userInteractionEnabled = YES;
}
- (void)openIAPOverlay {
    self.iapOverlay.hidden = YES;
}
@end
