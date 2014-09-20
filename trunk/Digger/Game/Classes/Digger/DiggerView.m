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

typedef enum {
    DirectionLeft,
    DirectionRight,
    DirectionDown
} Direction;

@interface DiggerView()

@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardLayer;

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
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen];
}

- (void)blockPressed:(NSNotification *)notification {
    BlockView *blockView = notification.object;
    //    CGPoint point = [[BoardManager instance] pointForTile:self.boardView.playerView.tileView];
    //    TileView *tileView = [[BoardManager instance] tileAtRow:point.x column:point.y];
    if (blockView.tileView) {
        Direction currentDirection = [self drillDirectionTo:blockView];
        NSLog(@"%d",currentDirection);
        [self.boardView refreshBoardLocalLock];
        [[BoardManager instance] movePlayerBlock:blockView.tileView];
        [UIView animateWithDuration:0.3f animations:^ {
            [self.boardView refreshBoardLocalOpen];
            if (currentDirection == DirectionDown) {
                [self.boardView shiftUp];
            }
        }];
    }
}

- (Direction)drillDirectionTo:(BlockView *)block {
    Direction direction = DirectionDown;
    GridPoint *playerPoint = [[BoardManager instance] pointForTile:self.boardView.playerView.tileView];
    GridPoint *targetPoint = [[BoardManager instance] pointForTile:block.tileView];
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
