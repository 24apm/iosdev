//
//  AnimatingDialogView.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"

@interface AnimatingDialogView : XibDialogView

- (void)popIn:(UIView *)view;
- (CGFloat)popOut:(UIView *)view;

@end
