//
//  PromoGameData.m
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PromoGameData.h"

@implementation PromoGameData

+ (PromoGameData *)setupWithImagePath:(NSString *)imagePath description:(NSString *)description actionURL:(NSString *)actionURL {
    PromoGameData *promoGameData = [[PromoGameData alloc] init];
    promoGameData.imagePath = imagePath;
    promoGameData.description = description;
    promoGameData.actionURL = actionURL;
    return promoGameData;
}

@end
