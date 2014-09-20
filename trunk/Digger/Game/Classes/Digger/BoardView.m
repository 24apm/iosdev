//
//  BoardView.m
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BoardView.h"
#import "TileView.h"
#import "ObstacleView.h"
#import "PlayerView.h"
#import "TreasureView.h"
#import "BoardView.h"
#import "LevelManager.h"
#import "GameConstants.h"
#import "NSArray+Util.h"
#import "BoardManager.h"
#import "GridPoint.h"



@interface BoardView()

@property (nonatomic) CGSize tileSize;

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (nonatomic) CGFloat view2Start;

@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    [[BoardManager instance] setupWithBoard:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.minimumZoomScale = 0.1;
    
    self.scrollView.size = self.size;
    
    self.tileSize = [BoardManager instance].tileSize;
    
    
    
    self.view1 = [[UIView alloc] init];
    self.view1.frame = CGRectMake(0,
                                  0,
                                  self.width,
                                  self.tileSize.height * NUM_ROW);
    self.view1.backgroundColor = [UIColor redColor];
    
    self.view2 = [[UIView alloc] init];
    self.view2.frame = CGRectMake(0,
                                  self.view1.height,
                                  self.width,
                                  self.tileSize.height * NUM_ROW);
    
    self.view2.backgroundColor = [UIColor blueColor];
    
    [self.scrollView addSubview:self.view1];
    [self.scrollView addSubview:self.view2];
    
    [self generateTiles:self.view1];
    [self generateTiles:self.view2];
    
    [self generateBlocks];
    [self generatePlayer];
    self.scrollView.contentSize = CGSizeMake(self.width, self.view1.height);
    self.view2Start = [BoardManager instance].tiles.count/NUM_COL * self.tileSize.height/2;
}

- (void)shiftUp {
    self.view1.y -= self.tileSize.height;
    self.view2.y -= self.tileSize.height;
    CGFloat boardSize = self.view2Start * -1 + 1;
    if (self.view1.y <= boardSize) {
        self.view1.y = self.view2Start;
        
    }
    if (self.view2.y <= boardSize) {
        self.view2.y = self.view2Start;
    }
}

- (void)generatePlayer {
    self.playerView = [[PlayerView alloc] init];
    NSArray *tiles = [[BoardManager instance] tilesAtRow:0];
    TileView *startingTile = [tiles randomObject];
    [[BoardManager instance] moveBlock:self.playerView toTile:startingTile];
}

- (void)generateBlocks {
    
    NSArray *currentLevelTypes = [[LevelManager instance] levelDataTypeFor:[BoardManager instance].tiles.count];
    NSArray *currentLevelTiers = [[LevelManager instance] levelDataTierFor:[BoardManager instance].tiles.count];
    
    int index = 0;
    for (TileView *tile in [BoardManager instance].tiles) {
        int currentType = [[currentLevelTypes objectAtIndex:index]intValue];
        int currentTier = [[currentLevelTiers objectAtIndex:index]intValue];
        index++;
        
        BlockView *blockView;
        
        switch (currentType) {
            case BlockTypeObstacle: {
                blockView = [[ObstacleView alloc] init];
                break;
            }
            case BlockTypeTreasure: {
                blockView = [[TreasureView alloc] init];
                break;
            }
            default: {
                blockView = [[BlockView alloc] init];
                break;
            }
        }
        [blockView setupWithTier:currentTier];
        [[BoardManager instance] moveBlock:blockView toTile:tile];
    }
}

- (void)generateTiles:(UIView *)view {
    for (int r = 0; r < NUM_ROW; r++) {
        for (int c = 0; c < NUM_COL; c++) {
            TileView *tileView = [[TileView alloc] init];
            tileView.frame = CGRectIntegral(CGRectMake(c * self.tileSize.width,
                                                       r * self.tileSize.height,
                                                       self.tileSize.width,
                                                       self.tileSize.height));
            [[BoardManager instance].tiles addObject:tileView];
            [view addSubview:tileView];
        }
    }
}

- (void)refreshBoardLocalLock {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForTile:self.playerView.tileView];
    
    if (playerPoint.col > 0) {
        
        TileView *openTile = [[BoardManager instance] tileAtRow:playerPoint.row column:playerPoint.col-1];
        openTile.blockView.blocker.hidden = NO;
    }
    if (playerPoint.col < NUM_COL-1) {
        TileView *openTile = [[BoardManager instance] tileAtRow:playerPoint.row column:playerPoint.col+1];
        openTile.blockView.blocker.hidden = NO;
    }
    if (playerPoint.row >= [BoardManager instance].tiles.count/NUM_COL-1 ) {
        TileView *openTile = [[BoardManager instance] tileAtRow:0 column:playerPoint.col];
        openTile.blockView.blocker.hidden = NO;
    } else {
        TileView *openTile = [[BoardManager instance] tileAtRow:playerPoint.row+1 column:playerPoint.col];
        openTile.blockView.blocker.hidden = NO;
    }
}

- (void)refreshBoardLocalOpen {
    
    GridPoint *playerPoint = [[BoardManager instance] pointForTile:self.playerView.tileView];
    
    if (playerPoint.col > 0) {
        TileView *openTile = [[BoardManager instance] tileAtRow:playerPoint.row column:playerPoint.col-1];
        openTile.blockView.blocker.hidden = YES;
    }
    if (playerPoint.col < NUM_COL-1) {
        TileView *openTile = [[BoardManager instance] tileAtRow:playerPoint.row column:playerPoint.col+1];
        openTile.blockView.blocker.hidden = YES;
    }
    if (playerPoint.row >= [BoardManager instance].tiles.count/NUM_COL-1 ) {
        TileView *openTile = [[BoardManager instance] tileAtRow:0 column:playerPoint.col];
        openTile.blockView.blocker.hidden = YES;
    } else {
        TileView *openTile = [[BoardManager instance] tileAtRow:playerPoint.row+1 column:playerPoint.col];
        openTile.blockView.blocker.hidden = YES;
    }
    
}

- (void)refreshBoard {
    for (TileView *tile in [BoardManager instance].tiles) {
        tile.blockView.blocker.hidden = NO;
    }
}

@end
