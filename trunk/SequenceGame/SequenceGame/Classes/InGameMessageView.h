//
//  InGameMessageView.h
//  NumberGame
//
//  Created by MacCoder on 2/23/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface InGameMessageView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)show;
- (void)show:(NSString *)text;

@end
