//
//  PromoIconView.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoIconView.h"
#import "PromoManager.h"

@interface PromoIconView()

@end

@implementation PromoIconView

- (void) setupLabel {
    self.nameLabel.shadowBlur = 5.0f * IPAD_SCALE;
}

- (void)setupWithPromoGameData:(PromoGameData *)gameData {
    self.promoGameData = gameData;
    self.frontView.hidden = YES;
    self.backView.hidden = NO;
    self.hasPressed = NO;
    self.backgroundView.alpha = 0.f;
    self.nameLabel.alpha = 0.f;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: gameData.imagePath]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconView.image = [UIImage imageWithData: data];
            self.nameLabel.text = self.promoGameData.title;
            [self setupLabel];
        });
    });
}

- (IBAction)backViewPressed:(id)sender {
    [self flip];
    self.hasPressed = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:ICON_PRESSED_NOTIFICATION object:self];
}

- (void)flip {
    [UIView transitionWithView:self
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        self.frontView.hidden = NO;
                        self.backView.hidden = YES;
                        
                    }
     
                    completion:^(BOOL finished) {
                        [self fadeInLabel];
                        [self fadeInAndOut:self.backgroundView];
                    }];
}

- (IBAction)promoPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:PROMO_ICON_CALLBACK object:self];
}

- (void)fadeInLabel {
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:[NSArray arrayWithObjects:fadeIn, nil]];
    [groupAnimation setDuration:1.f];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    [self.nameLabel.layer addAnimation:groupAnimation forKey:@"animateIn"];
    
}

- (void)fadeInAndOut:(UIView *)view {
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:0.5f];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:1.f];
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.duration = 1.8f;
    fadeInAndOut.repeatCount = HUGE_VAL;
    [view.layer addAnimation:fadeInAndOut forKey:@"fadeInAndOut"];
}
@end
