//
//  GameLayoutView.m
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimUtil.h"
#import "GameLayoutView.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "GameConstants.h"
#import "InGameMessageView.h"
#import "Utils.h"
#import "UserData.h"
#import "PromoDialogView.h"
#import "iRate.h"
#import "TrackUtils.h"

#define TIMES_PLAYED_BEFORE_PROMO 3

@interface GameLayoutView()

@property (nonatomic) int panNumbers;
@property (nonatomic) BOOL swipedBegan;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic, strong) NSString *tapPerSecond;
@property (nonatomic) float tapTotal;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong)NSMutableArray * timeAverage;
@property (nonatomic) float displayTPS;
@property (nonatomic) float oldDisplayTPS;
@property (nonatomic) int tapBonus;
@property (nonatomic) CFTimeInterval timeBonus;
@property (nonatomic) int pointBonus;
@property (nonatomic) int scorePerTap;
@property (nonatomic) int totalScorePerTap;
@property (nonatomic) CFTimeInterval timeBonusEnd;
@property (nonatomic) BOOL timeBonusOn;

@end

@implementation GameLayoutView

static int promoDialogInLeaderBoardCount = 0;

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
        
        // add pan recognizer to the view when initialized
        UITapGestureRecognizer *tapRecognized = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [tapRecognized setDelegate:self];
        [self addGestureRecognizer:tapRecognized]; // add to the view you want to detect swipe on
        [[UserData instance] addObserver:self forKeyPath:@"currentScore" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.backgroundView.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.backgroundView.clipsToBounds = YES;
        self.currentScoreLabel.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.timeAverage = [NSMutableArray array];
        self.displayTPS = 0.00;
        self.scorePerTap = 1;
        self.tapTotal = 0;
        self.tapBonus = 0;
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScore"])
    {
        float value = [[change objectForKey:NSKeyValueChangeNewKey]floatValue];
        self.currentScoreLabel.text = [Utils formatWithComma:value];
    }
}

- (void)generateNewBoard {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/15.f target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [UserData instance].currentScore = 0;
    self.startTime = CACurrentMediaTime();
    self.timeBonus = CACurrentMediaTime();
}

- (void)tapRecognized:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        self.totalScorePerTap = [UserData instance].currentScore + self.scorePerTap + self.pointBonus;
        [UserData instance].currentScore = self.totalScorePerTap;
        self.tapTotal = self.tapTotal + self.scorePerTap + self.pointBonus;
        self.tapBonus++;
    }
}


- (void)update {
    self.currentScoreLabel.text = [Utils formatWithComma:[UserData instance].currentScore];
    double gapTime = CACurrentMediaTime() - self.startTime;
    if (gapTime > 1) {
        self.startTime = CACurrentMediaTime();
        [self.timeAverage addObject:[NSNumber numberWithFloat:self.tapTotal]];
        if (self.timeAverage.count > 5) {
            [self.timeAverage removeObjectAtIndex:0];
        }
        self.oldDisplayTPS = self.displayTPS;
        self.displayTPS = [self tapTotalAverage:self.timeAverage];
        self.displayTPS = self.displayTPS / self.timeAverage.count;
        if (self.displayTPS <= 0) {
            [self.timeAverage removeAllObjects];
        }
        self.tapTotal = 0;
    }
    float showAnimationTPS = self.oldDisplayTPS;
    if (gapTime <= 1) {
        float gapValue = self.displayTPS - self.oldDisplayTPS;
        gapValue = gapValue * gapTime;
        showAnimationTPS = self.oldDisplayTPS + gapValue;
    }
    self.tapPerSecondLabel.text = [NSString stringWithFormat:@"%.2f", showAnimationTPS];
    
    if (self.tapBonus >= 5) {
        [self tapBonusActivate];
    }
    
    if (!self.timeBonusOn && CACurrentMediaTime() - self.timeBonus > 20) {
        [self timeBonusActivate];
    }
    
    if (self.timeBonusOn && CACurrentMediaTime() - self.timeBonusEnd > 5) {
        [self timeBonusDeactivate];
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
    self.pointBonus = 10;
    self.timeBonusEnd = CACurrentMediaTime() + 20;
    self.timeBonusOn = YES;
    NSLog(@"TIME");
}

- (void)timeBonusDeactivate {
    self.pointBonus = 0;
    self.timeBonus = CACurrentMediaTime() + 5;
    self.timeBonusOn = NO;
    NSLog(@"TIME END");
}
@end
