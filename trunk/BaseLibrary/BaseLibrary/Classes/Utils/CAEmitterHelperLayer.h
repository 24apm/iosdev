//
//  CAEmitterHelperLayer.h
//  BaseLibrary
//
//  Created by MacCoder on 10/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "Prefix.h"
#import <QuartzCore/QuartzCore.h>

@interface CAEmitterHelperLayer : CAEmitterLayer

@property (nonatomic) float lifeSpan;
@property (nonatomic, strong) UIImage *cellImage;

- (void)refreshEmitter;
+ (CAEmitterHelperLayer *)emitter:(NSString *)json onView:(UIView *)view;
- (CGFloat)totalDuration;

@end
