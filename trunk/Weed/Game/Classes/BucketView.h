//
//  BucketView.h
//  Clicker
//
//  Created by MacCoder on 5/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"
#import "ProgressBarComponent.h"
#import "AnimatedLabel.h"

@interface BucketView : AnimatingDialogView
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;
@property (strong, nonatomic) IBOutlet UIView *overlay;

@property (strong, nonatomic) IBOutlet UIImageView *bucketImage;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;

- (void)show;
@end
