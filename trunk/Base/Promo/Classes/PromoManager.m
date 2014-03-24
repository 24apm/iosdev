//
//  PromoManager.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoManager.h"
#import "Utils.h"

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
        [instance setupAds];
    }
    return instance;
}

- (void)setupAds {
    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.floppyball"
                                          imagePath:@"FlappyBallIcon100x100.png"
                                         description:@"Play Floppy Ball!"
                                           actionURL:@"itms-apps://itunes.apple.com/us/app/floppy-ball/id827253862?ls=1&mt=8"]];
    
    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.thenumbergame"
                                          imagePath:@"NGIcon120.png"
                                        description:@"Find the Number!"
                                          actionURL:@"itms-apps://itunes.apple.com/us/app/number-game-find-target/id838135269?ls=1&mt=8"]];
    
    [self addPromo:[PromoGameData setupWithBundleId:@"com.jeffrwan.whatstheanswer"
                                          imagePath:@"WTNappicon120x120.png"
                                        description:@"What is the Answer!"
                                          actionURL:@"itms-apps://itunes.apple.com/us/app/whats-the-answer/id832059498?ls=1&mt=8"]];
    // add more promos!
    // add more promos!
}

- (void)addPromo:(PromoGameData *)gameData {
    if (![gameData.bundleId isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
        [self.promos addObject:gameData];
    }
}

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

@end
