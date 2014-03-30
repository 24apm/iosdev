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

@property (strong, nonatomic) PromoGameData *promoGameData;

@end

@implementation PromoIconView

- (void)setupWithPromoGameData:(PromoGameData *)gameData {
    self.promoGameData = gameData;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: gameData.imagePath]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconView.image = [UIImage imageWithData: data];
        });
    });
}

- (IBAction)promoPressed:(id)sender {
    [[PromoManager instance] promoPressed:self.promoGameData];
    [[NSNotificationCenter defaultCenter] postNotificationName:PROMO_ICON_CALLBACK object:self];
}

@end
