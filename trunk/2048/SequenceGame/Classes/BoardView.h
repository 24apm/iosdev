//
//  BoardView.h
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#define GAMEPLAY_VIEW_DISMISSED_NOTIFICATION @"GAMEPLAY_VIEW_DISMISSED_NOTIFICATION"

@interface BoardView : XibView

- (void)generateRandomTile;
- (void)shiftTilesLeft;
- (void)shiftTilesRight;
- (void)shiftTilesUp;
- (void)shiftTilesDown;

@property (nonatomic) BOOL gameEnd;
@end
