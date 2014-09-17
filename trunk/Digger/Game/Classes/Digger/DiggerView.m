//
//  DiggerView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "DiggerView.h"
#import "BlockView.h"
#import "TileView.h"
#import "GameConstants.h"
#import "LevelManager.h"
#import "ObstacleView.h"
#import "PlayerView.h"
#import "TreasureView.h"

#define NUM_COL 5
#define NUM_ROW 20
#define MARGIN_BLOCK 10 * IPAD_SCALE

@interface DiggerView()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableSet *tiles;
@property (nonatomic) CGSize tileSize;

@end

@implementation DiggerView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setup {
    self.tiles = [NSMutableSet set];
    
    float blockWidth = self.width / NUM_COL;
    self.tileSize = CGSizeMake(blockWidth, blockWidth);
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.size = self.frame.size;
    [self addSubview:self.scrollView];
    
    [self generateTiles];
    [self generateBlocks];
    
    self.scrollView.contentSize = CGSizeMake(self.width, self.tileSize.height * NUM_ROW);
}

- (void)generateTiles {
    for (int r = 0; r < NUM_ROW; r++) {
        for (int c = 0; c < NUM_COL; c++) {
            TileView *tileView = [[TileView alloc] init];
            tileView.frame = CGRectIntegral(CGRectMake(c * self.tileSize.width,
                                                       r * self.tileSize.height,
                                                       self.tileSize.width,
                                                       self.tileSize.height));
            [self.tiles addObject:tileView];
            [self.scrollView addSubview:tileView];
        }
    }
}

- (void)generateBlocks {
    
    NSArray *currentLevelTypes = [[LevelManager instance] levelDataTypeFor:self.tiles.count];
    NSArray *currentLevelTiers = [[LevelManager instance] levelDataTierFor:self.tiles.count];
    
    int index = 0;
    for (TileView *tile in self.tiles) {
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
            case BlockTypePlayer: {
                blockView = [[PlayerView alloc] init];
                break;
            }
            default: {
                blockView = [[BlockView alloc] init];
                break;
            }
        }
        [blockView setupWithTier:currentTier];
        blockView.frame = tile.frame;
        [self.scrollView addSubview:blockView];
    }
}


- (void)positionBlocks {
    
}

@end
