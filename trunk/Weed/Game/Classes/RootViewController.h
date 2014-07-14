//
//  RootViewController.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameViewControllerBase.h"
#import "ParallaxWorldView.h"

@interface RootViewController : GameViewControllerBase
@property (strong, nonatomic) IBOutlet ParallaxWorldView *parallaxWorldView;

@end
