//
//  TileView.h
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "THLabel.h"

#define MAX_LEVEL_TILE_PRESSED @"MAX_LEVEL_TILE_PRESSED"

@interface TileView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UIButton *tileButton;

@property (nonatomic) int currentValue;
@property (nonatomic) int realValue;
@property (nonatomic) BOOL isMergeable;
@property (nonatomic) BOOL isMerged;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIImageView *blitImageView;

- (void)updateToRealLabel;
- (void)animateMergedTile;


@end
