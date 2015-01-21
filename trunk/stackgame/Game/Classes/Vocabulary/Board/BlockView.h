//
//  BlockView.h
//  StackGame
//
//  Created by MacCoder on 1/17/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface BlockView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;
- (void)blockLabelSetTo:(NSString *)string;
@end
