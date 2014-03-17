//
//  InGameMessageView.h
//  NumberGame
//
//  Created by MacCoder on 2/23/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface InGameMessageView : XibView

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)show;
- (void)show:(NSString *)text;
- (void)showImage:(NSString *)imageName;

@end
