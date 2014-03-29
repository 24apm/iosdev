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

@implementation PromoBannerView

- (void)setupWithPromoGameData:(PromoGameData *)gameData {
    if (gameData) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: gameData.imagePath]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconView.image = [UIImage imageWithData: data];
                self.descriptionLabel.text = gameData.description;
                self.actionUrl = gameData.actionURL;
                self.bundleId = gameData.bundleId;
            });
        });
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (IBAction)promoPressed:(id)sender {
    if (![self launchInstalledApp]) {
        [[PromoManager instance] goToAppStore:self.actionUrl];
    }
    [self setupWithPromoGameData:[[PromoManager instance] nextPromo]];
}

- (BOOL)launchInstalledApp {
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = @"";
    NSString *scheme = [self.bundleId stringByAppendingString:@"://"];
    NSString *ourPath = [scheme stringByAppendingString:URLEncodedText];
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        [ourApplication openURL:ourURL];
        return YES;
    } else {
        return NO;
    }
}

@end
