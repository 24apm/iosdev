//
//  PromoBannerView.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoBannerView.h"
#import "PromoManager.h"

@implementation PromoBannerView

- (void)setupWithPromoGameData:(PromoGameData *)gameData {
    self.iconView.image = [UIImage imageNamed:gameData.imagePath];
    self.descriptionLabel.text = gameData.description;
    self.actionUrl = gameData.actionURL;
}

- (IBAction)promoPressed:(id)sender {
    [[PromoManager instance] goToAppStore:self.actionUrl];
    [self setupWithPromoGameData:[[PromoManager instance] nextPromo]];
}

@end
