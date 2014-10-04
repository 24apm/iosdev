//
//  PowerView.h
//  Digger
//
//  Created by MacCoder on 9/20/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BlockView.h"

@interface PowerView : BlockView

- (void)setupWithTier:(NSUInteger)tier;
@property (nonatomic) NSInteger hp;
@end
