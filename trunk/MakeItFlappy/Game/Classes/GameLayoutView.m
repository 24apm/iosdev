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
#import "GameLoopTimer.h"
#import "GameManager.h"

#define TIME_BONUS_INTERVAL 1800.f
#define TIME_BONUS_ACTIVED_LIMIT 5.f
#define MAX_TAP_FOR_BONUS 500.f
#define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)

typedef enum {
    GameModeFlying,
    GameModeFlappy,
    GameModeAnimating
} GameMode;

@interface GameLayoutView()

@property (strong, nonatomic) IBOutlet UILabel *speedPerSecond;
@property (strong, nonatomic) IBOutlet ExpUIView *displayView;
@property (strong, nonatomic) IBOutlet DistanceUIView *distanceUIView;
@property (nonatomic, retain) ShopTableView *shopTableView;

@property (strong, nonatomic) IBOutlet UIImageView *shinyBackground;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) UIButton *previousSelectedButton;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBarTaps;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *airBar;

@property (strong, nonatomic) IBOutlet UIImageView *buttonImage;
@property (nonatomic) CGPoint characterStartPoint;
@property (nonatomic) double startTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerForBonus;
@property (nonatomic, strong) NSMutableArray *tapTotal;
@property (nonatomic, strong) NSMutableArray *tapTotalPoints;
@property (nonatomic, strong) NSMutableArray *holdingTotal;
@property (nonatomic, strong) NSMutableArray *holdingTotalPoints;
@property (nonatomic) double displayTPS;
@property (nonatomic) int currentIndexForImage;
@property (nonatomic) double oldDisplayTPS;
@property (nonatomic) double tapBonus;
@property (nonatomic) double timeBonus;
@property (nonatomic) double tapsPerSecond;
@property (nonatomic) double tapsPerSecondPoints;
@property (nonatomic) double holdingsPerSecond;
@property (nonatomic) double holdingsPerSecondPoints;
@property (nonatomic) double scorePerTap;
@property (nonatomic) double totalScorePerTap;
@property (nonatomic) double timeBonusEnd;
@property (nonatomic) BOOL timeBonusOn;
@property (nonatomic) double deleteTime;
@property (nonatomic) BOOL doDecay;
@property (nonatomic) double previousTime;
@property (nonatomic) double delay;
@property (nonatomic) int ticks;
@property (nonatomic, strong) BucketView* bucketView;
@property (nonatomic) double displayAverageTPS;
@property (nonatomic) int tapBonusLevel;
@property (nonatomic) int lastColorIndex;
@property (nonatomic) long double currentAir;
@property (nonatomic) long double currentMaxAir;
@property (nonatomic) long double airRecovery;
@property (nonatomic) long double airResistence;
@property (nonatomic) float tempForAnimatingAirBar;
@property (nonatomic) BOOL onGround;
@property (nonatomic) PowerUpType currentTableType;
@property (nonatomic) BOOL tapFlappy;
@property (nonatomic) double previousTimeForAir;
@property (nonatomic) long long heightDistance;
@property (nonatomic) long long heightSpeed;
@property (nonatomic) BOOL shopOpened;

@property (nonatomic, strong) NSMutableArray *bonusArray;
@property (nonatomic) BOOL bonusTapOn;
@property (nonatomic) double bonusStartTime;
@property (strong, nonatomic) IBOutlet UIView *iapOverlay;
@property (nonatomic) double maxTapScore;
@property (nonatomic) BOOL flyingModeOn;
@property (nonatomic) GameMode currentMode;
@property (nonatomic) BackgroundType currentBackground;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIView *shopOverlay;

@end

@implementation GameLayoutView

static int promoDialogInLeaderBoardCount = 0;

- (void)createShopView {
    self.shopTableView = [[ShopTableView alloc] init];
    [self addSubview:self.shopTableView];
    [self insertSubview:self.shopBarView aboveSubview:self.shopTableView];
    
    NSArray *itemIds = [[ShopManager instance] arrayOfitemIdsFor:POWER_UP_TYPE_UPGRADE];
    [self.shopTableView setupWithItemIds:itemIds];
    self.shopTableView.y = self.height;
}

- (IBAction)upgradePressed:(UIButton *)sender {
    [self shopTableAlphaTo:1.f];
    self.shopOpened = YES;
    [self showShopTableView:sender powerType:POWER_UP_TYPE_UPGRADE];
}

- (IBAction)achievementPressed:(UIButton *)sender {
    [[[BucketView alloc] init] show];
}

- (IBAction)ratingPressed:(UIButton *)sender {
    [TrackUtils trackAction:@"iRate" label:@"ratePressed"];
    [[iRate sharedInstance] promptIfNetworkAvailable];
}

- (IBAction)iapPressed:(UIButton *)sender {
    [self shopTableAlphaTo:1.f];
    if ([CoinIAPHelper sharedInstance].hasLoaded) {
        [self showShopTableView:sender powerType:POWER_UP_TYPE_IAP];
    } else {
        [[[ErrorDialogView alloc] init] show];
    }
}

- (void)shopTableViewDismissed {
    [self shopTableAlphaTo:0.5f];
    self.shopOpened = NO;
    self.previousSelectedButton.enabled = YES;
    self.previousSelectedButton = nil;
}

- (void)shopTableAlphaTo:(float)alpha {
    self.shopBarView.backgroundColor = [UIColor colorWithRed:37.f/255.f green:128.f/255.f blue:60.f/255.f alpha:alpha];
}

- (void)refreshTable {
    [self.shopTableView setupWithType:self.currentTableType];
}

- (void)showShopTableView:(UIButton *)button powerType:(PowerUpType)type {
    self.currentTableType = type;
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
        self.distanceUIView.hidden = YES;
        self.displayView.hidden = NO;
        self.backgroundView.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.backgroundView.clipsToBounds = YES;
        self.flyingModeOn = NO;
        self.onGround = YES;
        self.backgroundColorView.image = [self backgroundImageForTier:BackgroundTypeFloor];
        self.displayView.currentExpLabel.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.distanceUIView.currentDistanceLabel.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.tapTotal = [NSMutableArray array];
        self.tapTotalPoints = [NSMutableArray array];
        self.holdingTotalPoints = [NSMutableArray array];
        self.currentIndexForImage = 1;
        self.airResistence = 1;
        self.bonusArray = [NSMutableArray array];
        self.displayView.tpsLabel.text = [self expPerSec:self.displayTPS];
        self.distanceUIView.spsLabel.text = [self ftPerSec:self.displayTPS];
        self.scorePerTap = 1;
        self.tapBonus = 0;
        self.lastColorIndex = -1;
        [self shopTableAlphaTo:0.5f];
        self.previousTime = CURRENT_TIME;
        self.doDecay = NO;
        self.displayView.currentExpLabel.text = [NSString stringWithFormat:@"%@", [Utils formatLongLongWithComma:[UserData instance].currentScore]];
        self.tapsPerSecond = 0;
        self.holdingsPerSecondPoints = 0;
        self.tapBonusLevel = 1;
        [self.airBar fillBar:1.f];
        [self.progressBar fillBar:0.f];
        self.tapsPerSecondPoints = 0;
        self.holdingsPerSecondPoints = 0;
        self.previousTimeForAir = 0;
        self.currentMaxAir = [UserData instance].currentMaxAir;
        self.currentAir = self.currentMaxAir;
        self.airRecovery = 1;
        self.tempForAnimatingAirBar = 1.f;
        self.timeBonus = 0;
        self.heightDistance = 0;
        self.heightSpeed = 1;
        self.shopOpened = NO;
        self.shopOverlay.hidden = YES;
        [self animateButtonPressAndHold];
        
        self.iapOverlay.hidden = NO;
        [self.progressBarTaps fillBar:0.f];
        self.shinyBackground.hidden = YES;
        if (!self.shopTableView) {
            [self createShopView];
        }
        self.currentMode = GameModeFlappy;
        [self setupGestureHolding];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTable) name:UPGRADE_ATTEMPT_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopButtonPressed:) name:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopTableViewDismissed) name:SHOP_TABLE_VIEW_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateLabelForBonus:) name:BONUS_BUTTON_TAPPED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyPowerUp:) name:BUYING_PRODUCT_SUCCESSFUL_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyingProduct:) name:IAP_ITEM_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openIAPOverlay) name:IAP_ITEM_LOADED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawStep) name:DRAW_STEP_NOTIFICATION object:nil];
        
    }
    return self;
}

- (void)drawStep {
    
    if (self.currentMode == GameModeFlappy) {
        if (!self.onGround) {
            [self flappyUpdate];
        } else {
            [self onGroundUpdate];
        }
        
    } else if (self.currentMode == GameModeFlying){
        [self flyingUpdate];
    }
    
}

- (void)onGroundUpdate {
    self.shopOverlay.hidden = YES;
    self.currentMaxAir = [UserData instance].currentMaxAir * [[UserData instance] totalPowerUpFor:POWER_UP_TYPE_UPGRADE UpgradeType:SHOP_ITEM_ID_UPGRADE_AIR];
    self.currentAir = self.currentMaxAir;
    self.airRecovery = [UserData instance].currentAirRecovery * [[UserData instance] totalPowerUpFor:POWER_UP_TYPE_UPGRADE UpgradeType:SHOP_ITEM_ID_UPGRADE_FLAPPY];
    self.heightSpeed = [UserData instance].currentSpeed * [[UserData instance] totalPowerUpFor:POWER_UP_TYPE_UPGRADE UpgradeType:SHOP_ITEM_ID_UPGRADE_SPEED];
    [self.particleView showSpeedLines:NO];
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForStanding]];
}

- (void)shopButtonPressed:(NSNotification*)notification {
    self.shopBarView.alpha = 1.f;
    [self.shopTableView refresh];
    [self updateTPS];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScore"])
    {
        long long value = [[change objectForKey:NSKeyValueChangeNewKey]longLongValue];
        self.displayView.currentExpLabel.text = [NSString stringWithFormat:@"%@", [Utils formatLongLongWithComma:value]];
    }
}
- (void)generateNewGame {
    [self drawStep];
}

- (IBAction)tapPressedDown:(id)sender {
    self.characterImageView.transform = CGAffineTransformMakeScale(1.02f, 1.02f);
}

- (void)animateFlappy {
    if (self.tapFlappy) {
        self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlapping][1]];
    } else {
        self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlapping][0]];
    }
    self.tapFlappy = !self.tapFlappy;
}
- (IBAction)tapPressed:(id)sender {
    if (!self.onGround && self.currentMode == GameModeFlappy) {
        
        [self animateFlappy];
        
        if ([self tapTotalAverage:self.tapTotal] <= 0) {
            [self.tapTotal removeAllObjects];
        }
        long long perTap =[[UserData instance]addScore:self.timeBonusOn];
        [self updateTPSWithTap:perTap];
        
        self.tapsPerSecond++;
        
        [self animateLabel:perTap];
        //[[SoundManager instance]play:SOUND_EFFECT_GUINEA];
        self.characterImageView.transform = CGAffineTransformIdentity;
        
        [self recoverAir];
    }
}

- (void)recoverAir {
    self.currentAir+= self.airRecovery;
    if (self.currentAir > self.currentMaxAir) {
        self.currentAir = self.currentMaxAir;
    }
    float percentage = self.currentAir / self.currentMaxAir;
    [self.airBar fillBar:percentage];
    [self airBarStatus:percentage];
}

- (void)setupGestureHolding {
    UILongPressGestureRecognizer *holdGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holding:)];
    holdGestureRecognizer.delegate = self;
    [holdGestureRecognizer setMinimumPressDuration:0.8f];
    [self addGestureRecognizer:holdGestureRecognizer];
}

- (void)startFlyingMode {
    [self animateButtonPressAndHold];
    self.currentMode = GameModeFlying;
    self.shopOverlay.hidden = NO;
    self.distanceUIView.hidden = NO;
    [self.particleView showSpeedLines:YES];
    self.backgroundColorView.image = [self backgroundImageForTier:BackgroundTypeFlying];
    self.lastColorIndex = 6;
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlying]];
    if (self.tapTotal.count > 1) {
        [self.tapTotal removeObjectAtIndex:0];
        [self.tapTotalPoints removeObjectAtIndex:0];
    }
}

- (void)startFlappyMode {
    [self animateButtonPress];
    self.currentMode = GameModeFlappy;
    [self.particleView showSpeedLines:NO];
    self.distanceUIView.hidden = YES;
    self.backgroundColorView.image = [self backgroundImageForTier:self.currentBackground];
    self.lastColorIndex = 1;
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlapping][1]];
    if (self.holdingTotal.count > 1) {
        [self.holdingTotal removeObjectAtIndex:0];
        [self.holdingTotalPoints removeObjectAtIndex:0];
    }
}

- (void)holding:(UIPanGestureRecognizer *)sender {
    if (!self.shopOpened && self.currentMode != GameModeAnimating) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            self.previousTime = CURRENT_TIME;
            [self startFlyingMode];
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            self.previousTime = CURRENT_TIME;
            [self startFlappyMode];
            [self.holdingTotalPoints removeAllObjects];
        }
    }
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

- (void)updateTPSWithTap:(float)number {
    self.tapsPerSecondPoints += number;
    [self updateTPS];
}

- (void)updateTPS {
    self.displayTPS = self.tapsPerSecondPoints;
    if (self.tapTotal.count <= 0) {
        self.displayView.tpsLabel.text = [self expPerSec:self.displayTPS];
    }
}

- (void)updateAverageTPS {
    double average = [self tapTotalAverage:self.tapTotalPoints];
    if (average <= 0) {
        average = 0;
    }
    self.displayAverageTPS = average;
    self.displayView.tpsLabel.text = [self expPerSec:self.displayAverageTPS];
}

- (NSString *)ftPerSec:(long long)ft {
    return [NSString stringWithFormat:@"$%lldft/sec", ft];
}

- (NSString *)expPerSec:(long long)exp {
    return [NSString stringWithFormat:@"%lldexp/sec", exp];
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

- (UIImage *)backgroundImageForTier:(BackgroundType)tier {
    switch (tier) {
        case BackgroundTypeFlying:
            return [UIImage imageNamed:@"blackbackground"];
            break;
        case BackgroundTypeFloor:
            return [UIImage imageNamed:@"background_tier1"];
            break;
        case BackgroundTypeFloat:
            return [UIImage imageNamed:@"background_tier2"];
            break;
        case BackgroundTypeTree:
            return [UIImage imageNamed:@"background_tier3"];
            break;
        case BackgroundTypeSky:
            return [UIImage imageNamed:@"background_tier4"];
            break;
        case BackgroundTypeCloud:
            return [UIImage imageNamed:@"background_tier5"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)flappyUpdate {
    double time = CURRENT_TIME;
    double gapTime = time - self.previousTime;
    if (gapTime >= 1) {
        [[UserData instance] saveUserCoin];
        self.previousTime = time;
        
        if (self.tapsPerSecondPoints > 0) {
            if (self.maxTapScore < self.tapsPerSecondPoints) {
                self.maxTapScore = self.tapsPerSecondPoints;
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
        
        //[self levelOfTapBonus];
        
        if ([self tapTotalAverage:self.tapTotal] <= 0) {
            [self.tapTotal removeAllObjects];
            [self.tapTotalPoints removeAllObjects];
        }
        
        self.tapsPerSecond = 0;
        self.tapsPerSecondPoints = 0;
        
        [self updateAverageTPS];
    }
    
    [self updateTapBar];
    
    //    if (self.tapBonus >= MAX_TAP_FOR_BONUS) {
    //        [self tapBonusActivate];
    //        [self.progressBarTaps fillBar:0.f];
    //    }
    
    //    if (self.bonusTapOn) {
    //        [[SoundManager instance]play:SOUND_EFFECT_BLING];
    //        [self generateBonus];
    //        self.bonusTapOn = NO;
    //    }
    
    if (!self.timeBonusOn) {
        self.timeBonus++;
        double percentage = self.timeBonus / TIME_BONUS_INTERVAL;
        [self.progressBar fillBar:percentage];
    }
    
    if (!self.timeBonusOn && self.timeBonus >= TIME_BONUS_INTERVAL) {
        [self timeBonusActivate];
        [[SoundManager instance] play:SOUND_EFFECT_HALLELUJAH];
        
        [self animateRotation:self.shinyBackground];
        
        self.shinyBackground.hidden = NO;
        [self.progressBar fillBar:1.f];
    }
    
    if (self.timeBonusOn && time - self.timeBonusEnd > 5) {
        [self timeBonusDeactivate];
        self.shinyBackground.hidden = YES;
        //[self showPromoDialog];
        [self.progressBar fillBar:0.f];
    }
    [self decreaseCurrentAir];
}

- (void)flyingUpdate {
    double time = CURRENT_TIME;
    double gapTime = time - self.previousTime;
    if (gapTime >= 1) {
        self.previousTime = time;
        [self.holdingTotalPoints addObject:[NSNumber numberWithFloat:self.holdingsPerSecondPoints]];
        if (self.holdingTotalPoints.count > 0) {
            self.distanceUIView.spsLabel.text = [NSString stringWithFormat:@"%.fft/sec", [self tapTotalAverage:self.holdingTotalPoints]];
        }
        if (self.holdingTotalPoints.count > 2) {
            [self.holdingTotalPoints removeObjectAtIndex:0];
        }
        self.holdingsPerSecondPoints = 0.f;
    }
    self.holdingsPerSecondPoints += self.heightSpeed;
    if (self.holdingTotalPoints.count <= 0) {
        self.distanceUIView.spsLabel.text = [NSString stringWithFormat:@"%.fft/sec", self.holdingsPerSecondPoints];
    }
    self.onGround = NO;
    [self increaseHeight];
    [self decreaseCurrentAir];
    
}

- (void)increaseHeight {
    self.heightDistance += self.heightSpeed;
    self.distanceUIView.currentDistanceLabel.text = [Utils formatLongLongWithComma:[UserData instance].currentHeight];
    [[UserData instance] heightTierData:self.heightDistance];
    self.airResistence = [UserData instance].airResistence;
    self.currentBackground = [UserData instance].currentBackgroundTier;
    
    self.distanceLabel.text = [Utils formatLongLongWithComma:[UserData instance].currentHeight];
}

- (void)decreaseCurrentAir {
    double time = CURRENT_TIME;
    double gapTime = time - self.previousTimeForAir;
    self.previousTimeForAir = time;
    self.currentAir -= gapTime * self.airResistence;
    [self animatingAirbar];
    [self checkIfTired];
}
- (void)animatingAirbar {
    
    float percentage = self.currentAir / self.currentMaxAir;
    [self.airBar fillBar:percentage];
    
    [self airBarStatus:percentage];
}

- (void)checkIfTired {
    if (self.currentAir <= 0) {
        self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFalling]];
        self.currentMode = GameModeAnimating;
        [self animateFalling];
        self.buttonImage.hidden = YES;
        for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
            [self removeGestureRecognizer:recognizer];
        }
        
    }
}


- (void)animateFalling {
    self.characterStartPoint = self.characterImageView.center;
    CGPoint toPoint;
    toPoint.x = self.width/2;
    toPoint.y = self.height + self.height/3;
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0f];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:position, rotationAnimation, nil]];
    [groupAnimation setDuration:3.0f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [self.characterImageView.layer addAnimation:groupAnimation forKey:@"animateIn"];
    [self performSelector:@selector(finishFallAnimiation) withObject:nil afterDelay:groupAnimation.duration + 0.1f];
    
}


- (void)animateEntering {
    
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForStanding]];
    
    CGPoint fromPoint;
    fromPoint.x = self.characterStartPoint.x;
    fromPoint.y = -self.characterStartPoint.y;
    
    CGPoint toPoint;
    toPoint.x = self.characterStartPoint.x;
    toPoint.y = self.characterStartPoint.y;
    
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.fromValue = [NSNumber valueWithCGPoint:fromPoint];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:position, nil]];
    [groupAnimation setDuration:0.6f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [self.characterImageView.layer addAnimation:groupAnimation forKey:@"animateIn"];
    [self performSelector:@selector(finishEnterAnimiation) withObject:nil afterDelay:groupAnimation.duration + 0.1f];
    
}

- (void)finishFallAnimiation {
    [self animateEntering];
    self.currentBackground = BackgroundTypeFloor;
    self.backgroundColorView.image = [self backgroundImageForTier:self.currentBackground];
}


- (void)finishEnterAnimiation {
    [self restartGame];
}

- (void)restartGame {
    self.buttonImage.hidden = NO;
    [self animateButtonPressAndHold];
    [self setupGestureHolding];
    self.onGround = YES;
    self.currentMode = GameModeFlappy;
    [self onGroundUpdate];
    [[UserData instance] fellFromCurrentHeight:self.heightDistance];
    self.heightDistance = 0;
    self.currentAir = self.currentMaxAir;
    [self.airBar fillBar:1.f];
    [self airBarStatus:1.f];
}

- (void)airBarStatus:(float)percentage {
    if (percentage <= .2f) {
        self.airBar.foregroundView.backgroundColor = [UIColor redColor];
    } else {
        self.airBar.foregroundView.backgroundColor = [UIColor greenColor];
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


- (void)animateButtonPressAndHold {
    [self.buttonImage stopAnimating];
    self.buttonImage.image = [UIImage imageNamed:@"button_defualt"];
    
    
    self.buttonImage.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"button_default"],
                                        [UIImage imageNamed:@"button_press"],
                                        [UIImage imageNamed:@"button_hold"],
                                        [UIImage imageNamed:@"button_hold"],
                                        [UIImage imageNamed:@"button_hold"],
                                        [UIImage imageNamed:@"button_hold"],
                                        [UIImage imageNamed:@"button_hold"],
                                        [UIImage imageNamed:@"button_hold"],nil];
    
    // all frames will execute in 1.75 seconds
    self.buttonImage.animationDuration = 1.5f;
    // repeat the annimation forever
    self.buttonImage.animationRepeatCount = 0;
    // start animating
    [self.buttonImage startAnimating];
    // add the animation view to the main window
    [self addSubview:self.buttonImage];
}

- (void)animateButtonPress {
    [self.buttonImage stopAnimating];
    self.buttonImage.image = [UIImage imageNamed:@"button_defualt"];
    
    self.buttonImage.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"button_default"],
                                        [UIImage imageNamed:@"button_press"],nil];
    
    // all frames will execute in 1.75 seconds
    self.buttonImage.animationDuration = .3f;
    // repeat the annimation forever
    self.buttonImage.animationRepeatCount = 0;
    // start animating
    [self.buttonImage startAnimating];
    // add the animation view to the main window
    [self addSubview:self.buttonImage];
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
    //double time = CURRENT_TIME;
    //self.timeBonus = time;
    //[[UserData instance] saveUserStartTime:time];
    self.timeBonus = 0;
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
