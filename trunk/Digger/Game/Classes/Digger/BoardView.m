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



@interface BoardView()

@property (nonatomic) CGSize tileSize;

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
    
    [self generateTiles];
    [self generateBlocks];
    [self generatePlayer];
    self.scrollView.contentSize = CGSizeMake(self.width, self.tileSize.height * NUM_ROW);
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

- (void)generateTiles {
    for (int r = 0; r < NUM_ROW; r++) {
        for (int c = 0; c < NUM_COL; c++) {
            TileView *tileView = [[TileView alloc] init];
            tileView.frame = CGRectIntegral(CGRectMake(c * self.tileSize.width,
                                                       r * self.tileSize.height,
                                                       self.tileSize.width,
                                                       self.tileSize.height));
            [[BoardManager instance].tiles addObject:tileView];
            [self.scrollView addSubview:tileView];
        }
    }
}


@end
