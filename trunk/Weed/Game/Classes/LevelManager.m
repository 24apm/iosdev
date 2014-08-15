//
//  LevelManager.m
//  Weed
//
//  Created by MacCoder on 7/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LevelManager.h"
#import "Utils.h"
#import "RealEstateManager.h"
#import "UserData.h"

@interface LevelManager()

@property (strong, nonatomic) NSArray *durationTypes;
@property (strong, nonatomic) NSArray *durationModifier;

@end

@implementation LevelManager

+ (LevelManager *)instance {
    static LevelManager *instance = nil;
    if (!instance) {
        instance = [[LevelManager alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.durationTypes = @[@(1 * 60),
                               @(2 * 60)];
//        ,
//                           @(5 * 60),
//                           @(10 * 60),
//                           @(30 * 60),
//                           @(60 * 60)];
        
        self.durationModifier = @[@(1.f),
                               @(0.8f),
                               @(0.7f),
                               @(0.5f),
                               @(0.3f),
                               @(0.2f)];
    }
    return self;
}

#pragma mark - House
- (int)generateHouseSize {
    int houseSize;
    
    float showNextLevelContentThreshold = [Utils randBetweenMin:0.f max:1.0f];
    int count = 0;
    int userMaxHouseSize = [[RealEstateManager instance] userMaxHouseSize];
    if (showNextLevelContentThreshold > 0.7f) {
        count = userMaxHouseSize + 1;
    } else {
        count = [Utils randBetweenMinInt:1 max:userMaxHouseSize];
    }
    houseSize = CLAMP(count, 1, MAX_HOUSES);
    return houseSize;
}

- (long long)generateHouseCost:(int)houseSize {
    return [Utils randBetweenMinInt:80 max:100] * pow(2, houseSize * 2);
}

#pragma mark - Renter
- (int)generateRenterCount {
    return [Utils randBetweenMinInt:1 max:[[RealEstateManager instance] userMaxHouseSize]];
}

- (long long)generateRenterRate:(int)count duration:(long long)duration {
    double modifer = -1;
    
    for (int i = 0; i < self.durationTypes.count; i++) {
        if ([[self.durationTypes objectAtIndex:i] longLongValue] == duration) {
            modifer = [[self.durationModifier objectAtIndex:i] doubleValue];
            break;
        }
    }
    
    double durationMultiplier = duration * modifer / 60.f;
    return [Utils randBetweenMinInt:10 max:20] * pow(2, count * 2) * durationMultiplier;
}

- (long long)generateRenterDuration {
    int durationTypes = CLAMP(self.durationTypes.count, 1, [UserData instance].houses.count) ;
    int durationTypeIndex = arc4random() % durationTypes;
    long long duration = [[self.durationTypes objectAtIndex:durationTypeIndex] longLongValue];
    return duration;
}

- (int)generateRenterContractExpired {
    return [Utils randBetweenMinInt:1 max:1];
}

- (NSString *)generateRenterImagePath {
    return arc4random() % 2 == 0 ? @"male.png" : @"female.png";
}


@end
