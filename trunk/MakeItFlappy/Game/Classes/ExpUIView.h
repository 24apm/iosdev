//
//  ExpUIView.h
//  Make It Flappy
//
//  Created by MacCoder on 6/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface ExpUIView : XibView

@property (strong, nonatomic) IBOutlet UILabel *currentExpLabel;
@property (strong, nonatomic) IBOutlet UIImageView *expImage;
@property (strong, nonatomic) IBOutlet UILabel *tpsLabel;

- (void)show;
- (void)hide;

@end
