//
//  PromoGameData.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoGameData.h"

@implementation PromoGameData

+ (PromoGameData *)setupWithBundleId:(NSString *)bundleId
                           imagePath:(NSString *)imagePath
                         description:(NSString *)title
                           actionURL:(NSString *)actionURL {
    
    PromoGameData *promoGameData = [[PromoGameData alloc] init];
    promoGameData.bundleId = bundleId;
    promoGameData.imagePath = imagePath;
    promoGameData.title = title;
    promoGameData.actionURL = actionURL;
    return promoGameData;
}

@end
