//
//  ParallaxForegroundView.h
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface ParallaxForegroundView : XibView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setup;
- (void)refreshHouses;

@end
