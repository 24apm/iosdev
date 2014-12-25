//
//  PictureView.m
//  ImageFilter
//
//  Created by MacCoder on 12/20/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PictureView.h"
#import "GPUImage.h"

@implementation PictureView

- (id)init {
    self = [super init];
    if (self) {
        [self filter];
    }
    return self;
}

- (void)filter {
    UIImage *inputImage = self.picture.image;
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageToonFilter *stillImageFilter = [[GPUImageToonFilter alloc] init];
    stillImageFilter.threshold = 0.4;
    stillImageFilter.quantizationLevels = 8.0;
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    self.picture.image = currentFilteredVideoFrame;

}
@end
