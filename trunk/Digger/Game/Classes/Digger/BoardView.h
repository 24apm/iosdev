//
//  BoardView.h
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@class TileView;

@interface BoardView : UIView

- (void)setup;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PlayerView *playerView;

@end
