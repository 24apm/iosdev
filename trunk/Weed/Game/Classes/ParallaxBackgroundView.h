//
//  ParallaxBackgroundView.h
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "VisitorView.h"

@interface ParallaxBackgroundView : XibView
@property (strong, nonatomic) IBOutletCollection(VisitorView) NSArray *visitorViews;

- (void)setup;

@end
