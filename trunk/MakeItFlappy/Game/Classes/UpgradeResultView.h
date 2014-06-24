//
//  UpgradeResultView.h
//  Make It Flappy
//
//  Created by MacCoder on 6/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibDialogView.h"

@interface UpgradeResultView : XibDialogView
@property (strong, nonatomic) IBOutlet UIView *backgroundOverView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

- (void)showFail;
- (void)showSuccess;

@end
