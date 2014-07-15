//
//  UserData.m
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "UserData.h"
#import "GameCenterHelper.h"
#import "GameConstants.h"
#import "AnimatedLabel.h"
#import "NSArray+Util.h"

#define NEW_USER_COIN 10

NSString *const UserDataHouseDataChangedNotification = @"UserDataHouseDataChangedNotification";

@interface UserData()

@end

@implementation UserData

+ (UserData *)instance {
    static UserData *instance = nil;
    if (!instance) {
        instance = [[UserData alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Coin
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] == nil) {
            self.coin = NEW_USER_COIN;
            [self saveUserCoin];
        } else {
            self.coin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] integerValue];
        }
        
        // House
        self.houses = [NSMutableArray array];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"houses"] == nil) {
            [self addHouse:[HouseData dummyData]];
        } else {
            NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:@"houses"];
            
            NSStringEncoding  encoding = NSUTF8StringEncoding;
            NSData * jsonData = [jsonString dataUsingEncoding:encoding];
            NSError * error=nil;
            NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            
            for (NSDictionary *dict in parsedData) {
                HouseData *houseData = [[HouseData alloc] init];
                [houseData setupWithDict:dict];
                [self.houses addObject:houseData];
            }
        }
        
        // house index
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"houseIndex"] == nil) {
            self.houseIndex = 0;
        } else {
            self.houseIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"houseIndex"] integerValue];
        }
    }
    return self;
}

- (void)saveData:(NSObject *)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

- (void)saveUserCoin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    [self saveData:@(self.coin) forKey:@"coin"];
}

- (void)incrementCoin:(long long)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin += coin;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.coin) forKey:@"coin"];
    [defaults synchronize];
}

- (void)decrementCoin:(long long)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin -= coin;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.coin) forKey:@"coin"];
    [defaults synchronize];
}

- (void)saveHouse {
    NSMutableArray *houses = [NSMutableArray array];
    for (HouseData *houseData in self.houses) {
        [houses addObject:[houseData dictionary]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:houses options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self saveData:jsonString forKey:@"houses"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDataHouseDataChangedNotification object:nil];
}

- (void)addHouse:(HouseData *)houseData {
    self.houseIndex++;
    houseData.id = self.houseIndex;
    [self saveData:@(self.houseIndex) forKey:@"houseIndex"];
    
    [self.houses addObject:houseData];
    [self saveHouse];
}

- (void)removeHouse:(HouseData *)houseData {
    for (HouseData *data in self.houses) {
        if (data.id == houseData.id) {
            [self.houses removeObject:data];
            break;
        }
    }
    [self saveHouse];
}

- (HouseData *)randomUserHouse {
    return [self.houses randomObject];
}

@end
