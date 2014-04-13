//
//  TileView.h
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface TileView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;

@property (nonatomic) int currentValue;
@property (nonatomic) int realValue;

- (void)updateToRealLabel;
- (void)animateMergedTile;

@end
