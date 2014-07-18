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

#define TIME_BONUS_INTERVAL 1500.f
#define TIME_BONUS_ACTIVED_LIMIT 5.f
#define MAX_TAP_FOR_BONUS 500.f
#define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)
#define HOVERRANGE 30.f
#define STANDRANGE 1.f
#define FLYANIMATIONSPEED 10.f

typedef enum {
    GameModeFlying,
    GameModeFlappy,
    GameModeAnimating,
    GameModeAnimatingFlying,
    GameModeAnimatingFlyingEnd
} GameMode;

@interface GameLayoutView()

@property (nonatomic) int sonicNumber;
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
@property (nonatomic) BOOL onGroundTapAnimationOn;
@property (nonatomic) CGPoint characterDefaultPoint;
@property (strong, nonatomic) IBOutlet UILabel *lvlLabel;
@property (nonatomic) double pressTime;
@property (nonatomic) BOOL releaseTapEarly;

@property (nonatomic) BOOL hoveringDown;
@property (nonatomic) BOOL hoveringUp;
@property (nonatomic) BOOL buttonAnimatedForTap;
@property (nonatomic) BOOL buttonAnimatedForHold;
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
@property (nonatomic) long long currentMaxTap;
@property (nonatomic) double currentMaxTime;


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
    [TrackUtils trackAction:@"StatsScreenPressed" label:@"End"];
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
        self.buttonAnimatedForHold = NO;
        self.buttonAnimatedForTap = NO;
        self.backgroundView.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.backgroundView.clipsToBounds = YES;
        self.flyingModeOn = NO;
        self.sonicBoom.hidden = YES;
        self.onGround = YES;
        self.onGroundTapAnimationOn = NO;
        self.backgroundColorView.image = [GameLayoutView backgroundImageForTier:BackgroundTypeFloor];
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
        self.lvlLabel.text = [NSString stringWithFormat:@"%d",[[UserData instance] currentCharacterLevel]];
        self.heightSpeed = 1;
        self.shopOpened = NO;
        self.sonicNumber = 0;
        self.shopOverlay.hidden = YES;
        //        self.characterDefaultPoint = self.characterImageView.center;
        [self performSelector:@selector(nextTick) withObject:nil afterDelay:0.0f];
        self.hoveringDown = YES;
        self.hoveringUp = NO;
        [self resetUserData];
        self.startTime = 0.f;
        self.displayView.lvlLabel.text = [NSString stringWithFormat:@"%d",[[UserData instance] currentCharacterLevel]];
        self.releaseTapEarly = NO;
        
        self.iapOverlay.hidden = NO;
        [self.progressBarTaps fillBar:0.f];
        self.shinyBackground.hidden = YES;
        if (!self.shopTableView) {
            [self createShopView];
        }
        self.currentMode = GameModeFlappy;
        //[self setupGestureHolding];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLvl) name:SUCCESS_UPGRADE_ANIMATION_FINISH_NOTIFICATION object:nil];
        
    }
    return self;
}

- (void)nextTick {
    self.characterDefaultPoint = self.characterImageView.center;
}


- (void)updateLvl {
    self.displayView.lvlLabel.text = [NSString stringWithFormat:@"%d",[[UserData instance] currentCharacterLevel]];
    self.lvlLabel.text = [NSString stringWithFormat:@"%d",[[UserData instance] currentCharacterLevel]];
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
    } else if (self.currentMode == GameModeAnimatingFlying) {
        [self animateCharacterFlyingAnimationStart];
    } else if (self.currentMode == GameModeAnimatingFlyingEnd) {
        [self animateCharacterFlyingAnimationEnd];
    }
}

- (void)onGroundUpdate {
    //[self animateCharacterStanding];
    self.shopOverlay.hidden = YES;
    self.startTime = CURRENT_TIME;
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
    self.releaseTapEarly = NO;
    [self performSelector:@selector(holding) withObject:nil afterDelay:.8f];
}

- (IBAction)tapPressed:(id)sender {
    [self tapping];
    //[self increaseHeight];
    self.releaseTapEarly = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(holding) object:nil];
    if (self.currentMode == GameModeFlying) {
        self.currentMode = GameModeFlappy;
    }
}

- (void)animateFlappy {
    if (self.tapFlappy) {
        self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlapping][1]];
    } else {
        self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlapping][0]];
    }
    self.tapFlappy = !self.tapFlappy;
}

- (void)tapping {
    if (!self.onGround && self.currentMode == GameModeFlappy) {
        self.currentMaxTap++;
        [self animateFlappy];
        
        if ([self tapTotalAverage:self.tapTotal] <= 0) {
            [self.tapTotal removeAllObjects];
        }
        long long perTap =[[UserData instance]addScore:self.timeBonusOn];
        [self updateTPSWithTap:perTap];
        
        self.tapsPerSecond++;
        
        if (self.currentBackground != BackgroundTypeLast) {
            [self animateLabel:perTap];
        } else {
            [self animateLabelWithString:@"FLAP"];
        }
        //[[SoundManager instance]play:SOUND_EFFECT_GUINEA];
        self.characterImageView.transform = CGAffineTransformIdentity;
        
        [self recoverAir];
    }
    if (self.onGround) {
        if (!self.onGroundTapAnimationOn) {
            self.onGroundTapAnimationOn = YES;
            [self animateButtonPressAndHold];
        }
    }
    
    if (self.currentMode == GameModeFlying) {
        [self startFlappyMode];
    }
}

- (void)recoverAir {
    [[SoundManager instance] play:SOUND_EFFECT_FLAP];
    self.currentAir+= self.airRecovery;
    if (self.currentAir > self.currentMaxAir) {
        self.currentAir = self.currentMaxAir;
    }
    float percentage = self.currentAir / self.currentMaxAir;
    [self.airBar fillBar:percentage];
    [self airBarStatus:percentage];
    if (!self.buttonAnimatedForHold && percentage >= 0.8) {
        [self animateButtonPressAndHold];
        self.buttonAnimatedForHold = YES;
    }
}

- (void)playBackGroundMusic {
    if (self.currentBackground != BackgroundTypeBlackEntrance && self.currentBackground != BackgroundTypeLast) {
        [[SoundManager instance]play:SOUND_EFFECT_ELEVATOR repeat:YES];
    } else {
        [[SoundManager instance]stop:SOUND_EFFECT_ELEVATOR];
    }
}

- (void)startFlyingMode {
    [[SoundManager instance]stop:SOUND_EFFECT_WINDY];
    [[SoundManager instance]stop:SOUND_EFFECT_FORESTWIND];
    [self playBackGroundMusic];
    self.previousTime = CURRENT_TIME;
    self.buttonAnimatedForHold = NO;
    self.currentMode = GameModeFlying;
    self.shopOverlay.hidden = NO;
    self.distanceUIView.hidden = NO;
    [self.particleView showSpeedLines:YES];
    self.backgroundColorView.image = [GameLayoutView backgroundImageForTier:BackgroundTypeFlying];
    self.lastColorIndex = 6;
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlying]];
    if (self.tapTotal.count > 1) {
        [self.tapTotal removeObjectAtIndex:0];
        [self.tapTotalPoints removeObjectAtIndex:0];
    }
}

- (void)startFlappyMode {
    [[SoundManager instance]stop:SOUND_EFFECT_ELEVATOR];
    [self playWindSound];
    self.buttonAnimatedForTap = NO;
    self.currentMode = GameModeFlappy;
    [self.particleView showSpeedLines:NO];
    self.distanceUIView.hidden = YES;
    self.backgroundColorView.image = [GameLayoutView backgroundImageForTier:self.currentBackground];
    self.lastColorIndex = 1;
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlapping][1]];
    if (self.holdingTotal.count > 1) {
        [self.holdingTotal removeObjectAtIndex:0];
        [self.holdingTotalPoints removeObjectAtIndex:0];
    }
}

- (void)holding {
    if (!self.shopOpened && self.currentMode == GameModeFlappy) {
        self.currentMode = GameModeAnimatingFlying;
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
    float marginPercentage = 0.5f;
    float randX = arc4random() % (int)self.characterImageView.width * marginPercentage + self.characterImageView.width * marginPercentage / 2.f;
    float randY = arc4random() % (int)self.characterImageView.height * marginPercentage + self.characterImageView.height * marginPercentage / 2.f;
    label.center = CGPointMake(randX, randY);
    [label animate];
}

- (void)animateLabelWithStringCenter:(NSString *)string {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.characterImageView addSubview:label];
    label.label.text = string;
    label.label.textColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f];
    label.label.font = [label.label.font fontWithSize:100];
    float midX = self.characterImageView.center.x;
    float midY = self.characterImageView.center.y - (80 * IPAD_SCALE);
    label.center = CGPointMake(midX, midY);
    [label animateSlow];
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

- (float)tapTotalCombined {
    float temp = 0;
    for (int i = 0; i < self.tapTotal.count; i++) {
        temp  = temp + [[self.tapTotal objectAtIndex:i]floatValue];
    }
    return temp;
}

+ (UIImage *)backgroundImageForTier:(BackgroundType)tier {
    switch (tier) {
        case BackgroundTypeFlying:
            return [UIImage imageNamed:@"blackbackground"];
            break;
        case BackgroundTypeFloor:
            return [UIImage imageNamed:@"ground"];
            break;
        case BackgroundTypeGrass:
            return [UIImage imageNamed:@"grass"];
            break;
        case BackgroundTypeGrassFoot:
            return [UIImage imageNamed:@"grassfoot"];
            break;
        case BackgroundTypeGrassLeg:
            return [UIImage imageNamed:@"grassleg"];
            break;
        case BackgroundTypeGrassBody:
            return [UIImage imageNamed:@"grassbody"];
            break;
        case BackgroundTypeGrassHead:
            return [UIImage imageNamed:@"grasshead"];
            break;
        case BackgroundTypeFloat:
            return [UIImage imageNamed:@"float"];
            break;
        case BackgroundTypeTree:
            return [UIImage imageNamed:@"tree"];
            break;
        case BackgroundTypeSky:
            return [UIImage imageNamed:@"sky"];
            break;
        case BackgroundTypeCloud:
            return [UIImage imageNamed:@"cloud"];
            break;
        case BackgroundTypeMountain:
            return [UIImage imageNamed:@"mountain"];
            break;
        case BackgroundTypeAtmosphere:
            return [UIImage imageNamed:@"atmosphere"];
            break;
        case BackgroundTypeSpace:
            return [UIImage imageNamed:@"space"];
            break;
        case BackgroundTypeMoon:
            return [UIImage imageNamed:@"moon"];
            break;
        case BackgroundTypeVenus:
            return [UIImage imageNamed:@"venus"];
            break;
        case BackgroundTypeMercury:
            return [UIImage imageNamed:@"mercury"];
            break;
        case BackgroundTypeComet:
            return [UIImage imageNamed:@"comet"];
            break;
        case BackgroundTypeSun:
            return [UIImage imageNamed:@"sun"];
            break;
        case BackgroundTypeMars:
            return [UIImage imageNamed:@"mars"];
            break;
        case BackgroundTypeAsteroid:
            return [UIImage imageNamed:@"asteroid"];
            break;
        case BackgroundTypeBlackEntrance:
            return [UIImage imageNamed:@"blackholeentrance"];
            break;
        case BackgroundTypeLast:
            return [UIImage imageNamed:@"last"];
            break;
        case BackgroundTypeJupiter:
            return [UIImage imageNamed:@"jupiter"];
            break;
        case BackgroundTypeSaturn:
            return [UIImage imageNamed:@"saturn"];
            break;
        case BackgroundTypeUranus:
            return [UIImage imageNamed:@"uranus"];
            break;
        case BackgroundTypeNepture:
            return [UIImage imageNamed:@"neptune"];
            break;
        case BackgroundTypePluto:
            return [UIImage imageNamed:@"pluto"];
            break;
        case BackgroundTypeSolar:
            return [UIImage imageNamed:@"solar"];
            break;
        case BackgroundTypeGalaxy:
            return [UIImage imageNamed:@"galaxy"];
            break;
        case BackgroundTypeBlack:
            return [UIImage imageNamed:@"blackhole"];
            break;
        case BackgroundTypeOuterGalaxy:
            return [UIImage imageNamed:@"outergalaxy"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)playWindSound {
    if (self.currentBackground != BackgroundTypeBlackEntrance && self.currentBackground != BackgroundTypeLast) {
        [[SoundManager instance]play:[[UserData instance] windLevelCheck] repeat:YES];
        
    } else if (self.currentBackground == BackgroundTypeBlackEntrance) {
        [[SoundManager instance]stop:SOUND_EFFECT_WINDY];
        [[SoundManager instance]play:SOUND_EFFECT_FINAL repeat:YES];
        
    } else if (self.currentBackground == BackgroundTypeLast) {
        [[SoundManager instance]stop:SOUND_EFFECT_FINAL];
        [[SoundManager instance]play:SOUND_EFFECT_ENDING repeat:YES];
        
    }
}

- (void)flappyUpdate {
    [self animateCharacterHovering];
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
    }
    
    [self decreaseCurrentAir];
}

- (void)flyingUpdate {
    
    double time = CURRENT_TIME;
    double gapTime = time - self.previousTime;
    
    
    if (gapTime >= 0.5) {
        if (self.releaseTapEarly) {
            [self startFlappyMode];
        }
    }
    self.onGround = NO;
    [self increaseHeight];
    [self decreaseCurrentAir];
    
}

- (void)increaseHeight {
    self.heightDistance += self.heightSpeed;
    [[UserData instance] heightTierData:self.heightDistance];
    if ([UserData instance].sonicBoom) {
        [UserData instance].sonicBoom = NO;
        [self animateSonic];
    }
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
        [self saveUserData];
        [[SoundManager instance] stop:SOUND_EFFECT_ELEVATOR];
        [[SoundManager instance] stop:SOUND_EFFECT_WINDY];
        [[SoundManager instance] stop:SOUND_EFFECT_FORESTWIND];
        [[SoundManager instance] stop:SOUND_EFFECT_FINAL];
        [[SoundManager instance] stop:SOUND_EFFECT_ENDING];
        [[SoundManager instance] play:SOUND_EFFECT_FALL];
        [self animateFalling];
        self.buttonImage.hidden = YES;
        for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
            [self removeGestureRecognizer:recognizer];
        }
    }
}

- (void)saveUserData {
    self.currentMaxTime = CURRENT_TIME - self.startTime;
    [[UserData instance] saveMaxHeight:self.heightDistance];
    [[UserData instance] savefellNumber];
    [[UserData instance] saveMaxTime:self.currentMaxTime];
    [[UserData instance] saveTotalTap:self.currentMaxTap];
    [self resetUserData];
}

- (void)resetUserData {
    self.heightDistance = 0.f;
    self.currentMaxTap = 0.f;
    self.currentMaxTime = 0.f;
}
- (void)animateSonic {
    [[SoundManager instance]play:SOUND_EFFECT_SONIC];
    CGPoint fromPoint;
    fromPoint.x = self.characterImageView.center.x;
    fromPoint.y = self.characterImageView.frame.size.height;
    CGPoint toPoint;
    toPoint.x = self.center.x;
    toPoint.y = self.height;
    
    
    UIImageView *sonicBoom = [[UIImageView alloc] init];
    sonicBoom.image = [UIImage imageNamed:@"sonicboom"];
    sonicBoom.frame = CGRectMake(fromPoint.x, fromPoint.y, sonicBoom.image.size.width * IPAD_SCALE, sonicBoom.image.size.height* IPAD_SCALE);
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.fromValue = [NSNumber valueWithCGPoint:fromPoint];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation *scaleAnimation;
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.01f];
    scaleAnimation.toValue = [NSNumber numberWithFloat: 0.8f];
    
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.fromValue = [NSNumber numberWithFloat:1.0f];
    animateAlpha.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:position, scaleAnimation, animateAlpha, nil];
    groupAnimation.duration = 1.0f;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    [sonicBoom.layer addAnimation:groupAnimation forKey:@"animateIn"];
    
    
    [self.characterImageView.superview insertSubview:sonicBoom belowSubview:self.characterImageView];
    
    [sonicBoom performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:groupAnimation.duration];
}

- (void)animateFalling {
    CGPoint toPoint;
    toPoint.x = self.width/2;
    toPoint.y = self.height + self.height/3;
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0f];
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
    [self.particleView showSpeedLines:NO];
    CGRect newRect = self.characterImageView.frame;
    newRect.origin.y = self.characterDefaultPoint.y;
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForStanding]];
    
    CGPoint fromPoint;
    fromPoint.x = self.characterDefaultPoint.x;
    fromPoint.y = -self.characterDefaultPoint.y;
    
    CGPoint toPoint;
    toPoint.x = self.characterDefaultPoint.x;
    toPoint.y = newRect.origin.y;
    
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
    position.fromValue = [NSNumber valueWithCGPoint:fromPoint];
    position.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:position, nil]];
    [groupAnimation setDuration:0.6f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [self.characterImageView.layer addAnimation:groupAnimation forKey:@"animateIn"];
    [self performSelector:@selector(finishEnterAnimiation) withObject:nil afterDelay:groupAnimation.duration + 0.0f];
    
}

- (void)finishFallAnimiation {
    [self animateEntering];
    self.currentBackground = BackgroundTypeFloor;
    self.backgroundColorView.image = [GameLayoutView backgroundImageForTier:self.currentBackground];
}

- (void)finishEnterAnimiation {
    self.characterImageView.center = self.characterDefaultPoint;
    [[SoundManager instance] play:SOUND_EFFECT_LAND];
    [self.characterImageView.layer removeAllAnimations];
    [self restartGame];
}

- (void)restartGame {
    [TrackUtils trackAction:@"restartGame" label:@"End"];
    if (self.timeBonusOn) {
        [self timeBonusDeactivate];
    }
    [self showPromoDialog];
    self.distanceLabel.text = @"0";
    self.buttonAnimatedForTap = NO;
    self.buttonAnimatedForHold = NO;
    self.buttonImage.hidden = NO;
    [self animateButtonPressAndHold];
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
    if (percentage <= .4f) {
        self.airBar.foregroundView.backgroundColor = [UIColor redColor];
        if (!self.buttonAnimatedForTap && self.currentMode == GameModeFlying) {
            self.buttonAnimatedForTap = YES;
            [self animateButtonPress];
        }
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
                                        [UIImage imageNamed:@"pressandhold"],nil];
    
    // all frames will execute in 1.75 seconds
    self.buttonImage.animationDuration = 2.0f;
    // repeat the annimation forever
    self.buttonImage.animationRepeatCount = 1;
    // start animating
    [self.buttonImage startAnimating];
    // add the animation view to the main window
    [self addSubview:self.buttonImage];
    [self performSelector:@selector(buttonAnimateFinish) withObject:nil afterDelay:self.buttonImage.animationDuration * self.buttonImage.animationRepeatCount];
}

- (void)animateCharacterHovering {
    CGRect newRect = self.characterImageView.frame;
    float offset = 1.f * IPAD_SCALE;
    
    if (self.hoveringDown) {
        offset *= -1.f;
    } else if (self.hoveringUp){
        
    }
    
    if (self.hoveringDown && self.characterImageView.center.y < self.characterDefaultPoint.y - HOVERRANGE) {
        self.hoveringDown = NO;
        self.hoveringUp = YES;
    } else if (self.hoveringUp && self.characterImageView.center.y > self.characterDefaultPoint.y + HOVERRANGE) {
        self.hoveringDown = YES;
        self.hoveringUp = NO;
    }
    
    newRect.origin.y += offset;
    [self.characterImageView.layer removeAllAnimations];
    self.characterImageView.frame = newRect;
    // NSLog(@"self.characterImageView %@", NSStringFromCGRect(self.characterImageView.frame));
}

- (void)animateCharacterStanding {
    CGRect newRect = self.characterImageView.frame;
    float offset = 1.f;
    
    if (self.hoveringDown) {
        offset *= -1.f;
    } else if (self.hoveringUp){
        
    }
    
    if (self.hoveringDown && self.characterImageView.center.y < self.characterDefaultPoint.y - STANDRANGE) {
        self.hoveringDown = NO;
        self.hoveringUp = YES;
    } else if (self.hoveringUp && self.characterImageView.center.y > self.characterDefaultPoint.y + STANDRANGE) {
        self.hoveringDown = YES;
        self.hoveringUp = NO;
    }
    
    newRect.origin.y += offset;
    [self.characterImageView.layer removeAllAnimations];
    self.characterImageView.frame = newRect;
    // NSLog(@"self.characterImageView %@", NSStringFromCGRect(self.characterImageView.frame));
}

- (void)animateCharacterFlyingAnimationStart {
    [[SoundManager instance]play:SOUND_EFFECT_FLYUP];
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlying]];
    [self.characterImageView.layer removeAllAnimations];
    self.characterImageView.y += -FLYANIMATIONSPEED * 3 * IPAD_SCALE;;
    //  NSLog(@"self.characterImageView %@", NSStringFromCGRect(self.characterImageView.frame));
    
    if (self.characterImageView.center.y <  -self.characterDefaultPoint.y/2) {
        CGRect newRect = self.characterImageView.frame;
        float offset = self.height;
        newRect.origin.y = offset;
        self.characterImageView.frame = newRect;
        self.backgroundColorView.image = [GameLayoutView backgroundImageForTier:BackgroundTypeFlying];
        [self.particleView showSpeedLines:YES];
        self.currentMode = GameModeAnimatingFlyingEnd;
    }
}

- (void)animateCharacterFlyingAnimationEnd {
    self.characterImageView.image = [UIImage imageNamed:[GameManager characterImageForFlying]];
    self.characterImageView.y += -FLYANIMATIONSPEED * IPAD_SCALE;
    [self.characterImageView.layer removeAllAnimations];
    // NSLog(@"self.characterImageView %@", NSStringFromCGRect(self.characterImageView.frame));
    
    if (self.characterImageView.center.y < self.characterDefaultPoint.y/.95f) {
        //        CGRect newRect = self.characterImageView.frame;
        //        float offset = self.characterDefaultPoint.y;
        //        newRect.origin.y = offset;
        //        self.characterImageView.frame = newRect;
        self.previousTimeForAir = CURRENT_TIME;
        
        [self startFlyingMode];
    }
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
    self.buttonImage.animationRepeatCount = 5;
    // start animating
    [self.buttonImage startAnimating];
    // add the animation view to the main window
    [self addSubview:self.buttonImage];
    [self performSelector:@selector(buttonAnimateFinish) withObject:nil afterDelay:self.buttonImage.animationDuration * self.buttonImage.animationRepeatCount];
}

- (void) buttonAnimateFinish {
    self.onGroundTapAnimationOn = NO;
    [self.buttonImage stopAnimating];
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
    [TrackUtils trackAction:@"BonusActivated" label:@"End"];
    self.timeBonusEnd = CURRENT_TIME + TIME_BONUS_ACTIVED_LIMIT;
    [self animateLabelWithStringCenter:@"X10"];
    self.timeBonusOn = YES;
}

- (void)timeBonusDeactivate {
    self.timeBonus = 0;
    self.timeBonusOn = NO;
    self.shinyBackground.hidden = YES;
    [self.progressBar fillBar:0.f];
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
        [TrackUtils trackAction:@"FundApplied" label:@"End"];
        [UserData instance].currentScore += 100000;
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_DOUBLE]) {
        [TrackUtils trackAction:@"x2Applied" label:@"End"];
        [UserData instance].currentScore = [UserData instance].currentScore * 2;
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_QUADPLE]) {
        [TrackUtils trackAction:@"x4Applied" label:@"End"];
        [UserData instance].currentScore = [UserData instance].currentScore * 4;
        
    } else if ([productIdentifier isEqualToString:POWER_UP_IAP_SUPER]) {
        [TrackUtils trackAction:@"SuperApplied" label:@"End"];
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
