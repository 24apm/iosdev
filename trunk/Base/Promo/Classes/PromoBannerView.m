//
//  PromoBannerView.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoBannerView.h"
#import "PromoManager.h"
#import <CoreImage/CoreImage.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface PromoBannerView()

@property (strong, nonatomic) PromoGameData *promoGameData;

@end

@implementation PromoBannerView

- (void)setupWithPromoGameData:(PromoGameData *)gameData {
    if (gameData) {
        self.promoGameData = gameData;
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: gameData.imagePath]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconView.image = [UIImage imageWithData: data];
                self.descriptionLabel.text = gameData.description;
            });
        });
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (IBAction)promoPressed:(id)sender {
    [[PromoManager instance] promoPressed:self.promoGameData];
}


@end
