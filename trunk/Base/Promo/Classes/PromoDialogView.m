//
//  PromoDialogView.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoDialogView.h"
#import "PromoManager.h"

@implementation PromoDialogView

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(promoIconCallback:) name:PROMO_ICON_CALLBACK object:nil];
    }
    return self;
}

- (void)show {
    [super show];
    float delay = 0.f;
    
    delay += 0.5f;
    self.overlay.alpha = 0.f;
    [self performSelector:@selector(fadeIn:) withObject:self.overlay afterDelay:delay];

    delay += 0.5f;
    self.headerLabel.alpha = 0.f;
    [self performSelector:@selector(fadeIn:) withObject:self.headerLabel afterDelay:delay];

    NSArray *promoArray = [[PromoManager instance] nextPromoSetWithSize:3];
    for (int i = 0; i < promoArray.count; i++) {
        PromoIconView *promoIconView = [self.promoIcons objectAtIndex:i];
        [promoIconView setupWithPromoGameData:[promoArray objectAtIndex:i]];
        promoIconView.alpha = 0.f;
        
        delay += 0.3f;
        [self performSelector:@selector(fadeIn:) withObject:promoIconView afterDelay:delay];
    }
    
    delay += 0.5f;
    self.closeButton.alpha = 0.f;
    [self performSelector:@selector(fadeIn:) withObject:self.closeButton afterDelay:delay];

}

- (void)fadeIn:(UIView *)view {
    [UIView animateWithDuration:0.3f animations:^ {
        view.alpha = 1.0f;
    }];
}

- (void)promoIconCallback:(NSNotification *)notification {
    [self dismissed];
}

- (void)dismissed {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:self];
}

@end
