//
//  BlockView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface BlockView : XibView

@property (strong, nonatomic) IBOutlet UIView *block;

- (void)setupWithTier:(int)tier;

@end
