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

#define MAX_LIFE 10.f

typedef enum {
    DirectionLeft,
    DirectionRight,
    DirectionDown
} Direction;

@interface DiggerView()

@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardLayer;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *staminaBar;
@property (nonatomic) double stamina;
@property (nonatomic) double playerMargin;
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
}

- (void)newGame {
    self.playerMargin = 0;
    [self.boardView newGame];
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen];
    [self.staminaBar fillBar:1.f];
    self.stamina = MAX_LIFE;
    [self staminaBarStatus:1.f];
}

- (void)blockPressed:(NSNotification *)notification {
    BlockView *blockView = notification.object;
    //    CGPoint point = [[BoardManager instance] pointForSlot:self.boardView.playerView.slotView];
    //    SlotView *slotView = [[BoardManager instance] slotAtRow:point.x column:point.y];
    if (blockView.slotView) {
        Direction currentDirection = [self drillDirectionTo:blockView];
        NSLog(@"%d",currentDirection);
        [self.boardView refreshBoardLocalLock];
        [[BoardManager instance] movePlayerBlock:blockView.slotView];
        [UIView animateWithDuration:0.3f animations:^ {
            [self.boardView refreshBoardLocalOpen];
            if (currentDirection == DirectionDown && self.playerMargin >= 1) {
                [self.boardView shiftUp];
            }
        }];
        self.playerMargin++;
        [self actionByBlockType:blockView.type];
        [self.boardView generateBoardIfNecessary];
        if (self.stamina <= 0) {
            [self newGame];
        }
    }
}

- (void)actionByBlockType:(BlockType)type {
    switch (type) {
        case BlockTypeObstacle: {
            [self staminaBarDecrease:1.f];
            break;
        }
        case BlockTypePower: {
            [self staminaBarIncrease:2.f];
            
            break;
        }
        case BlockTypeTreasure: {
            
            break;
        }
        default: {
            
            break;
        }
    }
}

- (void)staminaBarDecrease:(NSUInteger)points {
    self.stamina -= points;
    double percentage = self.stamina/MAX_LIFE;
    [self staminaBarStatus:percentage];
    [self animateStaminaBar:percentage];
}

- (void)staminaBarIncrease:(NSUInteger)points {
    self.stamina += points;
    if (self.stamina >= MAX_LIFE) {
        self.stamina = MAX_LIFE;
    }
    double percentage = self.stamina/MAX_LIFE;
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
    NSLog(@"test");
    [PromoDialogView show];
}

- (void)positionBlocks {
    
}
@end
