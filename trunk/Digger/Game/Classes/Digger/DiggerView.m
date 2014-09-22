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
#import "UserData.h"
#import "UpgradeShopDialogView.h"

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
@end

@implementation DiggerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockPressed:) name:BLOCK_PRESSED_NOTIFICATION object:nil];
    }
    return self;
}

- (void)setup {
    self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, self.boardLayer.size.width, self.boardLayer.size.height)];
    [self.boardLayer addSubview:self.boardView];
    [self newGame];
    self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];

    [self.boardView addObserver:self forKeyPath:@"depth" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"depth"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];

        self.depthLabel.text = [NSString stringWithFormat:@"Depth: %ld", (long)newC];
    } else if ([keyPath isEqualToString:@"coin"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.coinLabel.text = [NSString stringWithFormat:@"%ld", (long)newC];
    }
}

- (void)newGame {
    self.playerMargin = 0;
    [self.boardView newGame];
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen];
    [[UserData instance] refillStamina];
    [self refreshStamina];
}

- (void)blockPressed:(NSNotification *)notification {
    BlockView *blockView = notification.object;
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
    [self handlePressed:blockView];

}

- (void)animateDownHandlePressed:(BlockView *)blockView {
   
    
}

- (void)handlePressed:(BlockView *)blockView {
    if (blockView.slotView) {
        if ([self actionByBlockType:blockView]) {
            Direction currentDirection = [self drillDirectionTo:blockView];
            NSLog(@"%d",currentDirection);
            [self.boardView refreshBoardLocalLock];
            [[BoardManager instance] movePlayerBlock:blockView.slotView];
            [self.boardView refreshBoardLocalOpen];
            if (currentDirection == DirectionDown && self.playerMargin >= 1) {
                [self.boardView generateBoardIfNecessary];
                [self.boardView shiftUp];
            }
            
            self.playerMargin++;
            if ([UserData instance].stamina <= 0) {
                [self newGame];
            }
        }
    }
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

- (BOOL)actionByBlockType:(BlockView *)blockView {
    switch (blockView.type) {
        case BlockTypeObstacle: {
            ObstacleView *obstacleView = (ObstacleView *)blockView;
            obstacleView.hp--;
            [self staminaBarDecrease:1.f];
            if (obstacleView.hp > 0) {
                return NO;
            } else {
                return YES;
            }
            break;
        }
        case BlockTypePower: {
            [self staminaBarIncrease:2.f];
            [self flyIconFrom:blockView.imageView toView:self.staminaImageView];
            return YES;
            break;
        }
        case BlockTypeTreasure: {
            [[UserData instance] incrementCoin:1];
            [self flyIconFrom:blockView.imageView toView:self.coinImageView];
            return YES;

            break;
        }
        default: {
            return YES;
            break;
        }
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

- (Direction)drillDirectionTo:(BlockView *)block {
    Direction direction = DirectionDown;
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.boardView.playerView.slotView];
    GridPoint *targetPoint = [[BoardManager instance] pointForSlot:block.slotView];
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
