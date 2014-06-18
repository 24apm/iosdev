//
//  ParticleView.h
//  Clicker
//
//  Created by MacCoder on 5/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticleView : UIView

@property (nonatomic, strong) CAEmitterLayer* fireEmitter;

-(void)changeAndRenewFireCell;
- (void)showSpeedLines:(BOOL)setting;

@end
