//
//  PromoManager.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoManager.h"
#import "Utils.h"
#import "TrackUtils.h"

@interface PromoManager()

@property (retain, nonatomic) NSMutableArray *promos;
@property (strong, nonatomic) PromoGameData *currentPromo;

@end

@implementation PromoManager

+ (PromoManager *)instance {
    static PromoManager *instance = nil;
    if (!instance) {
        instance = [[PromoManager alloc] init];
        instance.promos = [NSMutableArray array];
    }
    return instance;
}

//- (void)setupAds {
//    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.floppyball"
//                                          imagePath:@"FlappyBallIcon100x100.png"
//                                         description:@"Play Floppy Ball!"
//                                           actionURL:@"itms-apps://itunes.apple.com/us/app/floppy-ball/id827253862?ls=1&mt=8"]];
//    
//    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.thenumbergame"
//                                          imagePath:@"NGIcon120.png"
//                                        description:@"Find the Number!"
//                                          actionURL:@"itms-apps://itunes.apple.com/us/app/number-game-find-target/id838135269?ls=1&mt=8"]];
//    
//    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.whatstheanswer"
//                                          imagePath:@"WTNappicon120x120.png"
//                                        description:@"What is the Answer!"
//                                          actionURL:@"itms-apps://itunes.apple.com/us/app/whats-the-answer/id832059498?ls=1&mt=8"]];
//    
//    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.restroom"
//                                          imagePath:@"ToiletRush120.png"
//                                        description:@"Toilet Rush!"
//                                          actionURL:@"itms-apps://itunes.apple.com/us/app/toilet-rush/id844626495?ls=1&mt=8"]];
//    
//    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.blockandattack"
//                                          imagePath:@"RushyKnightIcon120.png"
//                                        description:@"Rushy Knight"
//                                          actionURL:@"itms-apps://itunes.apple.com/us/app/rushy-knight/id843104928?ls=1&mt=8"]];
//    // add more promos!
//    // add more promos!
//}

- (void)addPromo:(PromoGameData *)gameData {
    if (![gameData.bundleId isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
        [self.promos addObject:gameData];
    }
}

- (NSArray *)nextPromoSetWithSize:(int)size {
    NSMutableArray *randomPromos = [NSMutableArray arrayWithArray:self.promos];
    [randomPromos shuffle];
    NSRange range = NSMakeRange(0, MIN(size, randomPromos.count));
    return [randomPromos subarrayWithRange:range];
}

// Banner
- (PromoGameData *)nextPromo {
    if (!self.currentPromo) {
        self.currentPromo = [self.promos randomObject];
    } else {
        // filter remaining promos
        NSMutableArray *promosWithoutCurrent = [NSMutableArray array];
        for (PromoGameData *promo in self.promos) {
            if (![promo.bundleId isEqualToString:self.currentPromo.bundleId]) {
                [promosWithoutCurrent addObject:promo];
            }
        }

        if (promosWithoutCurrent.count > 0) {
            self.currentPromo = [promosWithoutCurrent randomObject];
        }
    }
    return self.currentPromo;
}

- (void)goToAppStore:(PromoGameData *)promoGameData {
    [self openAppStore:promoGameData];
}

- (void)promoPressed:(PromoGameData *)promoGameData {
    [TrackUtils trackAction:@"xpromo_banner_pressed" label:promoGameData.title];

    if (![self launchInstalledApp:promoGameData]) {
        [TrackUtils trackAction:@"xpromo_banner_goToAppStore" label:promoGameData.title];
        [self goToAppStore:promoGameData];
    }
    // [self setupWithPromoGameData:[[PromoManager instance] nextPromo]];
}

- (void)openAppStore:(PromoGameData *)promoGameData {
    // Initialize Product View Controller
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    
    // Configure View Controller
    [storeProductViewController setDelegate:self];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : promoGameData.trackId} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
            
        } else {
            // Present Store Product View Controller
            [[Utils rootViewController] presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [[Utils rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)launchInstalledApp:(PromoGameData *)promoGameData {
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = @"";
    NSString *scheme = [promoGameData.bundleId stringByAppendingString:@"://"];
    NSString *ourPath = [scheme stringByAppendingString:URLEncodedText];
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        [ourApplication openURL:ourURL];
        [TrackUtils trackAction:@"xpromo_banner_launchInstalledApp" label:promoGameData.title];
        return YES;
    } else {
        return NO;
    }
}

@end
