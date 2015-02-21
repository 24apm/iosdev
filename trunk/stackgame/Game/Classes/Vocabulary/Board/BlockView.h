//
//  BlockView.h
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "BlockManager.h"

@interface BlockView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) BlockType fruitType;
@property (nonatomic) BlockState state;

- (void)blockSetTo:(BlockType)type;
@end
