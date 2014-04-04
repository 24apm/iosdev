//
//  SlotView.h
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "TileView.h"

@interface SlotView : XibView

@property (nonatomic, retain) TileView *tileView;

@end
