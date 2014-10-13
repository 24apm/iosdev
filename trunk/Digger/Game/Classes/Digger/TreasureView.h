//
//  TreasureView.h
//  Digger
//
//  Created by MacCoder on 9/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BlockView.h"
#import "TreasureData.h"

@interface TreasureView : BlockView

- (void)setupWithTier:(NSUInteger)tier;
@property (nonatomic) NSUInteger tier;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
