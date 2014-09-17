//
//  BoardManager.h
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockView.h"
#import "TileView.h"
#import "BoardView.h"

#define NUM_COL 5
#define NUM_ROW 20
#define MARGIN_BLOCK 10 * IPAD_SCALE

@interface BoardManager : NSObject

+ (BoardManager *)instance;
- (void)setupWithBoard:(BoardView *)boardView;

- (TileView *)tileAtRow:(int)r column:(int)c;
- (NSArray *)tilesAtRow:(int)r;
- (CGPoint)pointForTile:(TileView *)tileView;

- (BOOL)isOccupied:(TileView *)tileView;

- (void)moveBlock:(BlockView *)blockView toTile:(TileView *)tileView;
- (void)movePlayerBlock:(TileView *)tileView;

@property (nonatomic) CGSize tileSize;
@property (strong, nonatomic) NSMutableArray *tiles;

@end
