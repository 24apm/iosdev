//
//  ProgressBarComponent.h
//  NumberGame
//
//  Created by MacCoder on 2/23/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarComponent : UIView

@property (nonatomic, retain) IBOutlet UIView *foregroundView;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;

- (void)fillBar:(CGFloat)percentage;
- (void)fillBar:(CGFloat)percentage animated:(BOOL)animated;

@end

@interface VerticalProgressBarComponent : ProgressBarComponent

@end
