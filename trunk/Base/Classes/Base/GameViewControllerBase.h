//
//  GameViewControllerBase.h
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <iAd/iAd.h>

@interface GameViewControllerBase : UIViewController <ADBannerViewDelegate>

@property (nonatomic, retain) ADBannerView *adBannerView;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
