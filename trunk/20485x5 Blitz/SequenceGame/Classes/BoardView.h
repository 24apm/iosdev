//
//  BoardView.h
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#define GAMEPLAY_VIEW_DISMISSED_NOTIFICATION @"GAMEPLAY_VIEW_DISMISSED_NOTIFICATION"
#define GAME_END_BUTTON_PRESSED_NOTIFICATION @"GAME_END_BUTTON_PRESSED_NOTIFICATION"
#define NO_MORE_MOVE_NOTIFICATION @"NO_MORE_MOVE_NOTIFICATION"
#define TILE_MOVE_ANIMATION_DURATION 0.2f

@interface BoardView : XibView

@property (strong, nonatomic) IBOutlet UIView *contentLayer;
@property (strong, nonatomic) IBOutlet UIView *backgroundLayer;

- (void)generateRandomTile;
- (void)shiftTilesLeft;
- (void)shiftTilesRight;
- (void)shiftTilesUp;
- (void)shiftTilesDown;
- (void)shuffleTiles;
- (void)generateNewBoard;
- (void)destroyTilesWith:(int)number;
- (BOOL)testTilesWith:(int)number;
@property (nonatomic) BOOL gameEnd;
@end
