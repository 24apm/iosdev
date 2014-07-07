//
//  DistanceUIView.h
//  Make It Flappy
//
//  Created by MacCoder on 6/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface DistanceUIView : XibView

@property (strong, nonatomic) IBOutlet UILabel *currentDistanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *distanceImage;
@property (strong, nonatomic) IBOutlet UILabel *spsLabel;

@end
