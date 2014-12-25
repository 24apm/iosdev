//
//  PictureView.h
//  ImageFilter
//
//  Created by MacCoder on 12/20/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface PictureView : XibView
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UIImageView *pictureDefault;

@end
