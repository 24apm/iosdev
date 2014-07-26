//
//  DialogViewManager.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XibDialogView.h"

@interface DialogViewManager : NSObject

+ (DialogViewManager *)instance;
- (void)show:(XibDialogView *)dialogView;
- (void)showWithNoOverlay:(XibDialogView *)dialogView;
- (void)dismissed:(XibDialogView *)dialogView;

@end
