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
#import "CoinIAPHelper.h"
#import "CAEmitterHelperLayer.h"

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


-(void)animateCoinsToIcon:(NSNotification *)notification {
    self.userInteractionEnabled = NO;
    NSString *productIdentifier = notification.object;
    
    [self animateCoins:productIdentifier];
}
- (IBAction)LvlButtonPressed:(id)sender {
    if ([UserData instance].coin >= self.cost) {
        [[UserData instance] decrementCoin:self.cost];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateCoinsToIcon:) name:APPLY_TRANSACTION_NOTIFICATION object:nil];
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

- (void)animateCoins:(NSString *)identifier {
    NSInteger gap = 4;
    double delay = 0;
    
    CGPoint convertedPoint = [self.upgradeIcon.superview convertPoint:self.upgradeIcon.center toView:self.superview];
    
    NSMutableArray *pointsBez = [NSMutableArray array];
    double distancex1 = convertedPoint.x/2;
    double distancey1 = convertedPoint.y/2;
    double distancex2 = (self.width - convertedPoint.x)/2;
    double distancey2 = convertedPoint.y/2;
    double distancex3 = (self.width - convertedPoint.x)/2;
    double distancey3 = (self.height - convertedPoint.y)/2;
    double distancex4 = convertedPoint.x/2;
    double distancey4 = (self.height - convertedPoint.y)/2;
    [pointsBez addObject:[NSValue valueWithCGPoint:CGPointMake(distancex1, distancey1)]];
    [pointsBez addObject:[NSValue valueWithCGPoint:CGPointMake(distancex2, distancey2)]];
    [pointsBez addObject:[NSValue valueWithCGPoint:CGPointMake(distancex3, distancey3)]];
    [pointsBez addObject:[NSValue valueWithCGPoint:CGPointMake(distancex4, distancey4)]];
    
    NSMutableArray *points = [NSMutableArray array];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(self.width, 0.f)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(self.width, self.height)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(0.f, self.height)]];
    for (NSInteger i = 0; i < gap; i ++) {
        CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectKeys.json" onView:self];
        cellLayer.cellImage = [UIImage imageNamed:@"key"];
        
        CGPoint start = [[points objectAtIndex:i] CGPointValue];
        
        CGPoint toPoint = convertedPoint;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:start];
        
        [path addQuadCurveToPoint:toPoint controlPoint:[[pointsBez objectAtIndex:i] CGPointValue]];
        
        CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
        position.removedOnCompletion = NO;
        position.fillMode = kCAFillModeBoth;
        position.path = path.CGPath;
        position.duration = cellLayer.lifeSpan;
        [cellLayer addAnimation:position forKey:@"animateIn"];
        delay = position.duration;
    }
    
    NSInteger value = [[[CoinIAPHelper iAPDictionary] objectForKey:identifier] integerValue];
    [self performSelector:@selector(animateLabelAtCoin:) withObject:[NSString stringWithFormat:@"%d", value] afterDelay:delay];
    [self performSelector:@selector(postApplyEffect:) withObject:identifier afterDelay:delay];
}

- (void)postApplyEffect:(NSString *)identifier {
    [[NSNotificationCenter defaultCenter]postNotificationName:APPLY_TRANSACTION_EFFECT_NOTIFICATION object:identifier];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.1f];
}

- (void)animateLabelAtCoin:(NSString *)string {
    self.userInteractionEnabled = YES;
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.text = string;
    label.label.textColor = [UIColor colorWithRed:0.f green:1.f blue:0.f alpha:1.f];
    label.label.font = [label.label.font fontWithSize:60];
        CGPoint convertedPoint = [self.upgradeIcon.superview convertPoint:self.upgradeIcon.center toView:self.superview];
    label.center = convertedPoint;
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
