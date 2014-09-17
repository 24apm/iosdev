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
}

- (void)blockPressed:(NSNotification *)notification {
    BlockView *blockView = notification.object;
    CGPoint point = [[BoardManager instance] pointForTile:self.boardView.playerView.tileView];
    point.x++;
    TileView *tileView = [[BoardManager instance] tileAtRow:point.x column:point.y];
    if (tileView) {
        [UIView animateWithDuration:0.3f animations:^ {
            [[BoardManager instance] movePlayerBlock:blockView.tileView];
        }];
    }
}

- (IBAction)testButtonPressed:(id)sender {
    NSLog(@"test");
}

- (void)positionBlocks {
    
}

@end
