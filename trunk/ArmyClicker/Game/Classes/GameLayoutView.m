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

#define TIME_BONUS_INTERVAL 60.f
#define TIME_BONUS_ACTIVED_LIMIT 5.f

@interface GameLayoutView()

@property (nonatomic, retain) ShopTableView *shopTableView;

@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) UIButton *previousSelectedButton;

@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic, strong) NSString *tapPerSecond;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong)NSMutableArray * tapTotal;
@property (nonatomic) double displayTPS;
@property (nonatomic) double oldDisplayTPS;
@property (nonatomic) double tapBonus;
@property (nonatomic) double timeBonus;
@property (nonatomic) double scorePerTap;
@property (nonatomic) double totalScorePerTap;
@property (nonatomic) double timeBonusEnd;
@property (nonatomic) BOOL timeBonusOn;
@property (nonatomic) double deleteTime;
@property (nonatomic) BOOL doDecay;
@property (nonatomic) double delay;
@property (nonatomic) double tempPassiveLabel;
@property (nonatomic) int ticks;

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
    [self showShopTableView:sender powerType:POWER_UP_TYPE_OFFLINE];
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
        self.displayTPS = [[UserData instance] totalPointForPassive];
        self.tapPerSecondLabel.text = [self timePerSec:self.displayTPS];
        self.scorePerTap = 1;
        self.tapBonus = 0;
        self.deleteTime = 0;
        self.delay = 0;
        self.ticks = 0;
        self.doDecay = NO;
        [self.progressBar fillBar:0.f];
        self.tempPassiveLabel = [UserData instance].currentScore;
        if (!self.shopTableView) {
            [self createShopView];
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopButtonPressed) name:SHOP_BUTTON_PRESSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopTableViewDismissed) name:SHOP_TABLE_VIEW_NOTIFICATION object:nil];

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
    [self offlinePowerActivate];
    [self checkIfSavedTimePassedTimeBonus];
    
}

- (IBAction)tapPressedDown:(id)sender {
    self.characterImageView.transform = CGAffineTransformMakeScale(1.02f, 1.02f);
}


- (IBAction)tapPressed:(id)sender {
    float currentTap = (float)([[UserData instance] totalPointPerTap:self.timeBonusOn]);
    [[UserData instance]addScore:currentTap];
    [self updateTPSWithTap:currentTap];
    self.tapBonus++;
    [self animateLabel:[[UserData instance] totalPointPerTap:self.timeBonusOn]];
    
    self.characterImageView.transform = CGAffineTransformIdentity;

    
    static int rand = 0;
    rand = arc4random() % 4 + 1;
    self.characterImageView.image = [UIImage imageNamed:[self characterImageTier:rand]];
    
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
    if (self.doDecay == NO) {
        self.delay = 2.f;
        self.deleteTime = [[NSDate date] timeIntervalSince1970] * 1000;
    }
    [self startDecayTPS];
    self.doDecay = YES;
    [self.tapTotal addObject:[NSNumber numberWithFloat:number]];
    if (self.tapTotal.count > 20) {
        [self.tapTotal removeObjectAtIndex:0];
    }
    [self updateTPS];
}

- (void)updateTPS {
    self.displayTPS = [self tapTotalCombined] + [[UserData instance] totalPointForPassive];
    self.tapPerSecondLabel.text = [self timePerSec:self.displayTPS];
}

- (NSString *)timePerSec:(int)sec {
    return [NSString stringWithFormat:@"$%.1f/sec", self.displayTPS];
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

- (void)decayTPS {
    if (self.tapTotal.count > 0) {
        [self.tapTotal removeObjectAtIndex:0];
    } else {
        self.doDecay = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(decayTPS) object:nil];
    }
    [self updateTPS];
    
}

- (void)startDecayTPS {
    
    if (self.tapTotal.count > 15) {
        self.delay += .02f;
    } else if (self.tapTotal.count > 13){
        self.delay += .05f;
    } else if (self.tapTotal.count > 8) {
        self.delay += .1f;
    } else if (self.tapTotal.count > 5) {
        self.delay += .2f;
    }
    [self performSelector:@selector(decayTPS) withObject:nil afterDelay:self.delay];
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
    self.ticks++;
    self.tempPassiveLabel = [[UserData instance] currentScore];
    self.tempPassiveLabel += [[UserData instance] totalPointForPassive] / UPDATE_TIME_PER_TICK;
    [[UserData instance] addScoreByPassive];
    if (self.ticks >= (int)(UPDATE_TIME_PER_TICK)) {
        self.ticks = 0;
        [[UserData instance] saveUserCoin];
        self.startTime = time;
        [[UserData instance] saveUserLogInTime:time];
    }
    
    if (self.tapBonus >= 5) {
        [self tapBonusActivate];
    }
    
    if (!self.timeBonusOn) {
        double percentage = (time - self.timeBonus) / TIME_BONUS_INTERVAL;
        [self.progressBar fillBar:percentage];
        
       // NSLog(@"[CURRENT_TIME; %f ", CURRENT_TIME);

      //  NSLog(@"[self.timeBonus]; %f ", self.timeBonus);
     //   NSLog(@"(CURRENT_TIME - self.timeBonus) %f ", (CURRENT_TIME - self.timeBonus));

     //   NSLog(@"[self.progressBar fillBar:percentage]; %f ", percentage);

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

- (float)tapTotalAverage:(NSMutableArray *)array {
    float totalAverage = 0;
    for (int i = 0; i < array.count; i++) {
        totalAverage = totalAverage + [[array objectAtIndex:i] floatValue];
    }
    
    return totalAverage;
}

- (void)tapBonusActivate {
    self.tapBonus = 0;
    NSLog(@"BONUS");
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

- (void)offlinePowerActivate {
    [[UserData instance] addScoreByOffline];
    [[UserData instance] saveUserLogInTime:CURRENT_TIME];
}
@end
