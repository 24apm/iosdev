//
//  DiggerView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "DiggerView.h"
#import "GameConstants.h"
#import "LevelManager.h"
#import "BoardView.h"
#import "BoardManager.h"
#import "GridPoint.h"
#import "PromoDialogView.h"
#import "ProgressBarComponent.h"
#import "ObstacleView.h"
#import "PowerView.h"
#import "UserData.h"
#import "UpgradeShopDialogView.h"
#import "Utils.h"
#import "ShopTableView.h"
#import "WaypointView.h"
#import "CAEmitterHelperLayer.h"

typedef enum {
    DirectionLeft,
    DirectionRight,
    DirectionDown
} Direction;

@interface DiggerView()

@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardLayer;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *staminaBar;
@property (nonatomic) double playerMargin;
@property (strong, nonatomic) IBOutlet UILabel *depthLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coinImageView;
@property (strong, nonatomic) IBOutlet UIImageView *staminaImageView;
@property (strong, nonatomic) IBOutlet UILabel *staminaLabel;
@property (strong, nonatomic) IBOutlet UILabel *retryLabel;
@property (strong, nonatomic) IBOutlet UIButton *wayPoint;
@property (nonatomic) BOOL tableViewOpen;
@property (nonatomic) TableType currentTableType;
@property (nonatomic, retain) ShopTableView *shopTableView;

@end

@implementation DiggerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slotPressed:) name:SLOTS_PRESSED_NOTIFICATION object:nil];
    }
    return self;
}

- (void)setup {
    self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, self.boardLayer.size.width, self.boardLayer.size.height)];
    self.tableViewOpen = NO;
    [self.boardLayer addSubview:self.boardView];
    [self newGame];
    self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];
    self.retryLabel.text = [NSString stringWithFormat:@"Retry Left: %d", [UserData instance].retry];
    [self createShopView:self.currentTableType];
    //    [self.boardView addObserver:self forKeyPath:@"depth" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"retry" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movedToDepth:) name:WAYPOINT_ITEM_PRESSED_NOTIFICATION object:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"depth"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.depthLabel.text = [NSString stringWithFormat:@"Depth: %ld", (long)newC];
    } else if ([keyPath isEqualToString:@"coin"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.coinLabel.text = [NSString stringWithFormat:@"%ld", (long)newC];
    } else if ([keyPath isEqualToString:@"retry"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.retryLabel.text = [NSString stringWithFormat:@"Retry Left: %d", newC];
    }
}

- (void)newGame {
    self.playerMargin = 0;
    [self.boardView newGame];
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen:YES];
    [self.boardView hideBoardLocalEmptyEffect:YES];
    [[UserData instance] refillStamina];
    [self refreshStamina];
    [[UserData instance] resetDepth];
    [self updateDepthLabel];
    
}

- (void)movedToDepth:(NSNotification *)notification {
    WaypointRowItem *item = notification.object;
    NSUInteger depthTarget = item.level + 1;
    [[UserData instance] resetDepth];
    [[UserData instance] incrementDepth:depthTarget];
    [self.boardView newGameWaypointTo:depthTarget];
    self.playerMargin = 0;
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen:YES];
    [self.boardView hideBoardLocalEmptyEffect:YES];
    [[UserData instance] refillStamina];
    [self refreshStamina];
    [self updateDepthLabel];
    
}
- (void)updateDepthLabel {
    self.depthLabel.text = [NSString stringWithFormat:@"Depth: %d",[UserData instance].currentDepth];
}

- (void)slotPressed:(NSNotification *)notification {
    SlotView *slotView = notification.object;
    //    CGPoint point = [[BoardManager instance] pointForSlot:self.boardView.playerView.slotView];
    //    SlotView *slotView = [[BoardManager instance] slotAtRow:point.x column:point.y];
    
    //    if (blockView.type == BlockTypeObstacle) {
    //        Direction currentDirection = [self drillDirectionTo:blockView];
    //        CGFloat duration = 0.3f;
    //        int steps = 20;
    //        NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    //        double value = 0;
    //        float e = 2.71;
    //        CGFloat distance;
    //        if (currentDirection == DirectionDown) {
    //            distance = self.boardView.playerView.height / 2;
    //            for (int t = 0; t < steps; t++) {
    //                value = distance * pow(e, -0.055*t) * sin(-0.08*t) + distance / 2;
    //                [values addObject:[NSNumber numberWithFloat:value]];
    //            }
    //
    //            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    //            bounceAnimation.values = values;
    //            bounceAnimation.duration = duration;
    //            [self.boardView.playerView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    //        } else if (currentDirection == DirectionLeft) {
    //            distance = self.boardView.playerView.width / 2;
    //            for (int t = 0; t < steps; t++) {
    //                value = distance * pow(e, -0.055*t) * (1 - cos(-0.08*t)) + distance / 2;
    //                [values addObject:[NSNumber numberWithFloat:value]];
    //            }
    //
    //            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    //            bounceAnimation.values = values;
    //            bounceAnimation.duration = duration;
    //            [self.boardView.playerView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    //        } else if (currentDirection == DirectionRight) {
    //            distance = self.boardView.playerView.width / 2;
    //
    //            for (int t = 0; t < steps; t++) {
    //                value = distance * pow(e, -0.055*t) * cos(-0.08*t) + distance / 2;
    //                [values addObject:[NSNumber numberWithFloat:value]];
    //            }
    //
    //            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    //            bounceAnimation.values = values;
    //            bounceAnimation.duration = duration;
    //            [self.boardView.playerView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    //        }
    //        [self performSelector:@selector(handlePressed:) withObject:blockView afterDelay:duration + 0.2f];
    //
    //    } else {
    //        [self handlePressed:blockView];
    //    }
    [self handlePressed:slotView];
    
}

- (void)bombPressed:(SlotView *)slotView {
    [self.boardView findBombBlockOnSlot:slotView];
    [self.boardView cleanBombSet];
}

- (void)handlePressed:(SlotView *)slotView {
    // [self bombPressed:slotView];
    if ([self.boardView isNeighboringSlot:slotView]) {
        if ([self actionByBlockType:slotView]) {
            Direction currentDirection = [self drillDirectionTo:slotView];
            [self.boardView refreshBoardLocalOpen:NO];
            [self.boardView hideBoardLocalEmptyEffect:YES];
            [[BoardManager instance] movePlayerBlock:slotView];
            [self.boardView refreshBoardLocalOpen:YES];
            [self.boardView hideBoardLocalEmptyEffect:NO];
            
            if (currentDirection == DirectionDown && self.playerMargin >= 1) {
                [self.boardView generateBoardIfNecessary];
                self.boardView.depth++;
                [self.boardView shiftUp];
            }
            if (currentDirection == DirectionDown) {
                [UserData instance].currentDepth++;
                [self updateDepthLabel];
                self.playerMargin++;
            }
        }
        if ([UserData instance].stamina <= 0) {
            [[UserData instance] decrementRetry];
            [[UserData instance]resetDepth];
            if (YES || [[UserData instance] hasRetry]) {
                [self.boardView hideBoardLocalEmptyEffect:YES];
                [self newGame];
            } else {
                self.boardView.userInteractionEnabled = NO;
            }
        }
    }
}

- (IBAction)wayPointButtonPressed:(UIButton *)sender {
    self.tableViewOpen = YES;
    self.currentTableType = TableTypeWaypoint;
    [self showTableView:sender tableType:self.currentTableType];
}

- (void)showTableView:(UIButton *)button tableType:(TableType)type {
    //button.enabled = NO;
    [self.shopTableView setupWithType:type];
    [self.shopTableView showTable];
}

- (void)createShopView:(TableType)type {
    self.shopTableView = [[ShopTableView alloc] init];
    [self addSubview:self.shopTableView];
    
    NSArray *itemIds = [[TableManager instance] arrayOfitemIdsFor:type];
    [self.shopTableView setupWithItemIds:itemIds];
    self.shopTableView.y = self.height;
}

- (void)flyIconFrom:(UIImageView *)fromView toView:(UIImageView *)toView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:fromView.image];
    [self addSubview:imageView];
    imageView.frame = [fromView.superview convertRect:fromView.frame toView:imageView.superview];
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        imageView.frame = [toView.superview convertRect:toView.frame toView:imageView.superview];
    } completion:^(BOOL complete) {
        [imageView removeFromSuperview];
    }];
}

- (BOOL)actionByBlockType:(SlotView *)slotView {
    if (slotView.blockView) {
        switch (slotView.blockView.type) {
            case BlockTypeObstacle: {
                ObstacleView *obstacleView = (ObstacleView *)slotView.blockView;
                [self staminaBarDecrease:obstacleView.hp];
                CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffect.json" onView:self.boardView.playerView];
                cellLayer.cellImage = slotView.blockView.imageView.image;
                [cellLayer refreshEmitter];
                [self.boardView.playerView.slotView.superview bringSubviewToFront:self.boardView.playerView.slotView];

                return YES;
                break;
            }
            case BlockTypePower: {
                PowerView *powerView = (PowerView *)slotView.blockView;
                [self staminaBarIncrease:2.f * powerView.hp];
                [self flyIconFrom:slotView.blockView.imageView toView:self.staminaImageView];
                [CAEmitterHelperLayer emitter:@"particleEffect.json" onView:self.boardView.playerView].cellImage = slotView.blockView.imageView.image;
                [self.boardView.playerView.slotView.superview bringSubviewToFront:self.boardView.playerView.slotView];

                return YES;
                break;
            }
            case BlockTypeTreasure: {
                [[UserData instance] incrementCoin:1];
                [self flyIconFrom:slotView.blockView.imageView toView:self.coinImageView];
                [CAEmitterHelperLayer emitter:@"particleEffect.json" onView:self.boardView.playerView].cellImage = slotView.blockView.imageView.image;
                [self.boardView.playerView.slotView.superview bringSubviewToFront:self.boardView.playerView.slotView];

                [self staminaBarDecrease:1.f];
                return YES;
                
                break;
            }
            case BlockTypeWaypoint: {
                [[UserData instance] unlockWaypointRank:slotView.blockView.tier];
                [self staminaBarDecrease:1.f];
                return YES;
                
                break;
            }
            default: {
                return YES;
                break;
            }
        }
    } else {
        return YES;
    }
}

- (void)staminaBarDecrease:(NSUInteger)points {
    [[UserData instance] decrementStamina:points];
    [self refreshStamina];
}

- (void)staminaBarIncrease:(NSUInteger)points {
    [[UserData instance] incrementStamina:points];
    [self refreshStamina];
}

- (void)refreshStamina {
    self.staminaLabel.text = [NSString stringWithFormat:@"%lld/%lld", [UserData instance].stamina,[UserData instance].staminaCapacity];
    double percentage = [[UserData instance] formatPercentageStamina];
    
    [self staminaBarStatus:percentage];
    [self animateStaminaBar:percentage];
    
}

- (void)animateStaminaBar:(double)percentage {
    [UIView animateWithDuration:0.3f animations:^ {
        [self.staminaBar fillBar:percentage];
    }];
}

- (void)staminaBarStatus:(float)percentage {
    if (percentage <= .4f) {
        self.staminaBar.foregroundView.backgroundColor = [UIColor redColor];
    } else {
        self.staminaBar.foregroundView.backgroundColor = [UIColor greenColor];
    }
}

- (Direction)drillDirectionTo:(SlotView *)slotView {
    Direction direction = DirectionDown;
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.boardView.playerView.slotView];
    GridPoint *targetPoint = [[BoardManager instance] pointForSlot:slotView];
    if (playerPoint.col > targetPoint.col) {
        direction = DirectionLeft;
    } else if (playerPoint.col < targetPoint.col) {
        direction = DirectionRight;
    } else {
        direction = DirectionDown;
    }
    return direction;
}

- (IBAction)testButtonPressed:(id)sender {
    [[[UpgradeShopDialogView alloc] init] show];
}

- (void)positionBlocks {
    
}
@end
