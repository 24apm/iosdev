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
    [self addPromo:[PromoGameData setupWithImagePath:@"FlappyBallIcon100x100.png"
                                         description:@"Play Floppy Ball!"
                                           actionURL:@"itms-apps://itunes.apple.com/us/app/floppy-ball/id827253862?ls=1&mt=8"]];
}

- (void)addPromo:(PromoGameData *)gameData {
    [self.promos addObject:gameData];
}

- (PromoGameData *)nextPromo {
    return [self.promos randomObject];
}

- (void)goToAppStore:(NSString *)actionURL {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionURL]];
}

@end
