//
//  RealEstateManager.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RealEstateManager.h"
#import "UserData.h"
#import "Utils.h"

@interface RealEstateManager()

@property (strong, nonatomic) NSMutableDictionary *cachedHouseImages;

@end

@implementation RealEstateManager

- (id)init {
    self = [super init];
    if (self) {
        self.cachedHouseImages = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (RealEstateManager *)instance {
    static RealEstateManager *instance = nil;
    if (!instance) {
        instance = [[RealEstateManager alloc] init];
    }
    return instance;
}

- (BOOL)canPurchaseHouse:(HouseData *)data {
    return [self canPurchaseHouseWithHouseLimit:data] && [self canPurchaseHouseWithMoney:data];
}

- (BOOL)canPurchaseHouseWithMoney:(HouseData *)data {
    return [UserData instance].coin >= data.cost;
}

- (BOOL)canPurchaseHouseWithHouseLimit:(HouseData *)data {
    return [UserData instance].houses.count < 10;
}

- (BOOL)purchaseHouse:(HouseData *)data {
    if ([self canPurchaseHouse:data]) {
        [[UserData instance] decrementCoin:data.cost];
        [[UserData instance] addHouse:data];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canSellHouse {
    return [UserData instance].houses.count > 1;
}

- (void)sellHouse:(HouseData *)data buyerPrice:(double)buyerPrice {
    [[UserData instance] incrementCoin:buyerPrice];
    [[UserData instance] removeHouse:data];
}

- (BOOL)canCollectMoney:(HouseData *)data {
    return data.renterData && CURRENT_TIME > data.renterData.timeDue;
}

- (BOOL)collectMoney:(HouseData *)data {
    if ([self canCollectMoney:data]) {
        data.renterData.timeDue = CURRENT_TIME + data.renterData.duration;
        data.renterData.contractCurrentCount++;
        [[UserData instance] incrementCoin:data.renterData.cost];
        [[UserData instance] saveHouse];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canCollectAnyHouseMoney {
    NSArray *houses = [UserData instance].houses;
    for (HouseData *house in houses) {
        if ([self canCollectMoney:house]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasRenterContractExpired:(HouseData *)data {
    return data.renterData.contractCurrentCount >= data.renterData.contractExpired;
}

- (BOOL)canAddRenter:(HouseData *)data {
    if ([RealEstateManager instance].currentRenterData) {
        return [RealEstateManager instance].currentRenterData.renterData.count <= data.unitSize;
    }
    return NO;
}

- (BOOL)addRenter:(HouseData *)data {
    if ([self canAddRenter:data]) {
        data.renterData = [RealEstateManager instance].currentRenterData.renterData;
        data.renterData.timeDue = CURRENT_TIME + data.renterData.duration;
        [RealEstateManager instance].currentRenterData = nil;
        [[UserData instance] saveHouse];
        return YES;
    } else {
        return NO;
    }
}

- (void)removeRenter:(HouseData *)data {
    data.renterData = nil;
    [[UserData instance] saveHouse];
}

- (NSString *)imageForHouseUnitSize:(int)unitSize {
    return [NSString stringWithFormat:@"House%d.png",unitSize];
}

- (UIImage *)imageForHouseUnitSize:(int)unitSize tinted:(BOOL)tinted {
    NSString *key = [NSString stringWithFormat:@"%d_%d", unitSize, tinted];
    
    UIImage *image = [self.cachedHouseImages objectForKey:key];
    if (!image) {
        UIImage *originalImage = [UIImage imageNamed:[self imageForHouseUnitSize:unitSize]];
        [self.cachedHouseImages setObject:originalImage forKey:[NSString stringWithFormat:@"%d_%d", unitSize, NO]];
        
        UIImage *tintedImage = [Utils imageNamed:originalImage withColor:[UIColor colorWithWhite:0.f alpha:0.5f] blendMode:kCGBlendModeMultiply];
        
        [self.cachedHouseImages setObject:tintedImage forKey:[NSString stringWithFormat:@"%d_%d", unitSize, YES]];
        image = [self.cachedHouseImages objectForKey:key];
    }
    
    return image;
}

- (int)userMaxHouseSize {
    NSArray *houses = [UserData instance].houses;
    int max = 0;
    for (HouseData *house in houses) {
        if (house.unitSize > max) {
            max = house.unitSize;
        }
    }
    return max;
}

@end
