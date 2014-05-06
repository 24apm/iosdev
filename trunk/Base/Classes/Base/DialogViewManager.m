//
//  DialogViewManager.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "DialogViewManager.h"
#import "Utils.h"

@interface DialogViewManager()

@property (nonatomic, strong) NSMutableArray *dialogs;
@property (nonatomic, strong) UIView *overlay;

@end

@implementation DialogViewManager

+ (DialogViewManager *)instance {
    static DialogViewManager *instance = nil;
    if (!instance) {
        instance = [[DialogViewManager alloc] init];
        instance.dialogs = [NSMutableArray array];
    }
    return instance;
}

- (void)showOverlay:(BOOL)show {
    if (show) {
        if (!self.overlay) {
            self.overlay = [[UIView alloc] init];
            self.overlay.frame = [Utils rootViewController].view.frame;
            self.overlay.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
            [[Utils rootViewController].view addSubview:self.overlay];
        }
        [self fadeIn:self.overlay];
    } else {
        [self fadeOut:self.overlay];
    }
}

- (void)fadeIn:(UIView *)view {
    [view.layer removeAnimationForKey:@"alphaIn"];
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.fromValue = @(0.f);
    animateAlpha.toValue = @(1.f);
    animateAlpha.duration = 0.2f;
    animateAlpha.removedOnCompletion = NO;
    animateAlpha.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animateAlpha forKey:@"alphaIn"];
    view.alpha = 1.0f;
}

- (void)fadeOut:(UIView *)view {
    [view.layer removeAnimationForKey:@"alphaOut"];
    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.fromValue = @(1.f);
    animateAlpha.toValue = @(0.f);
    animateAlpha.duration = 0.2f;
    animateAlpha.removedOnCompletion = NO;
    animateAlpha.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animateAlpha forKey:@"alphaOut"];
    view.alpha = 0.f;
}

- (void)dismissed:(XibDialogView *)dialogView {
    [self.dialogs removeObject:dialogView];
    if (self.dialogs.count == 0) {
        [self showOverlay:NO];
    } else {
        [self showOverlay:YES];
    }
    [dialogView removeFromSuperview];
}

- (void)show:(XibDialogView *)dialogView {
    [self show:dialogView withOverlay:YES];
}

- (void)showWithNoOverlay:(XibDialogView *)dialogView {
    [self show:dialogView withOverlay:NO];
}

- (void)show:(XibDialogView *)dialogView withOverlay:(BOOL)overlayFlag {
    [self.dialogs addObject:dialogView];
    if (overlayFlag && self.dialogs.count == 1) {
        [self showOverlay:YES];
    } else {
        [self showOverlay:NO];
    }
    [[Utils rootViewController].view addSubview:dialogView];
    dialogView.frame = [Utils rootViewController].view.frame;
}

@end
