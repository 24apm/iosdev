//
//  GameViewControllerBase.h
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <iAd/iAd.h>
#import "PromoBannerView.h"
#import "GAITrackedViewController.h"

typedef enum {
    AdBannerPositionModeTop,
    AdBannerPositionModeBottom
} AdBannerPositionMode;

@interface GameViewControllerBase : GAITrackedViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) ADBannerView *adBannerView;


// override ad position
- (AdBannerPositionMode)adBannerPositionMode;

@end
