//
//  FoundWordDialogView.m
//  Vocabulary
//
//  Created by MacCoder on 10/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CompletedLevelDialogView.h"
#import "CAEmitterHelperLayer.h"

@interface CompletedLevelDialogView()

@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) BLOCK block;
@property (strong, nonatomic) IBOutlet UIView *animateView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *replayBigButton;
@property (strong, nonatomic) IBOutlet UIButton *replaySmallButton;
@property (strong, nonatomic) IBOutlet UIButton *bookButton;
@end

@implementation CompletedLevelDialogView

- (id)initForState:(NSString *)state; {
    self = [super init];
    if (self) {
        if ([state isEqualToString:GAME_END]) {
            self.replaySmallButton.hidden = YES;
            self.bookButton.hidden = YES;
            self.messageLabel.text = @"You have just completed a level!";
        } else if ([state isEqualToString:GAME_END_NEW]) {
            self.replayBigButton.hidden = YES;
            self.messageLabel.text = @"You have just unlocked new set of words!";
            [CAEmitterHelperLayer emitter:@"particleEffectSlowBurst.json" onView:self.animateView];
        }
    }
    
    return self;
}

- (IBAction)dismissButtonPressed:(UIButton *)sender {
    [self dismissed:self];
}

- (IBAction)nextPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:START_NEW_GAME_NOTIFICATION object:nil];
    [self dismissed:self];
}
- (IBAction)bookPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:OPEN_BOOK_NOTIFICATION object:nil];
}

//- (void)popIn:(UIView *)view {
//    CAKeyframeAnimation *popIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    popIn.values = @[@(0.f), @(1.2f), @(0.9f), @(1.0f)];
//    popIn.duration = 1.0f;
//    [view.layer addAnimation:popIn forKey:@"popIn"];
//
//    CGFloat rotations = 3;
//    CGFloat duration = 1;
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
//    rotationAnimation.duration = duration;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = YES;
//
//    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//}

@end
