//
//  PromoManager.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoManager.h"
#import "Utils.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

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

- (void)goToAppStore:(NSString *)actionURL {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionURL]];
}

- (void)promoPressed:(PromoGameData *)promoGameData {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"xpromo_banner"     // Event category (required)
                                                          action:@"xpromo_banner_pressed"  // Event action (required)
                                                           label:promoGameData.description          // Event label
                                                           value:nil] build]];    // Event value
    
    if (![self launchInstalledApp:promoGameData.bundleId]) {
        [[PromoManager instance] goToAppStore:promoGameData.actionURL];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"xpromo_banner"     // Event category (required)
                                                              action:@"xpromo_goToAppStore"  // Event action (required)
                                                               label:promoGameData.description          // Event label
                                                               value:nil] build]];    // Event value
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"xpromo_banner"     // Event category (required)
                                                              action:@"xpromo_launchInstalledApp"  // Event action (required)
                                                               label:promoGameData.description          // Event label
                                                               value:nil] build]];    // Event value
    }
    // [self setupWithPromoGameData:[[PromoManager instance] nextPromo]];
}

- (BOOL)launchInstalledApp:(NSString *)bundleId {
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = @"";
    NSString *scheme = [bundleId stringByAppendingString:@"://"];
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
