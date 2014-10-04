//
//  ObstacleVIew.h
//  Digger
//
//  Created by MacCoder on 9/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BlockView.h"

@interface ObstacleView : BlockView

- (void)setupWithTier:(NSUInteger)tier;

@property (strong, nonatomic) IBOutlet UILabel *tierLabel;
@property (nonatomic) NSInteger hp;

@end
