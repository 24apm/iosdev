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
#import "TrackUtils.h"
#import "CoinIAPHelper.h"
#import "CoinView.h"

#define NEW_USER_COIN 1000

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
        [self setup];
    }
    return self;
}

- (void)setup {
    // Coin
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] == nil) {
        self.coin = NEW_USER_COIN;
        [self saveData:@(self.coin) forKey:@"coin"];
    } else {
        self.coin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] integerValue];
    }
    
    // Stamina Capacity
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"staminaCapacity"] == nil) {
        self.staminaCapacity = DEFAULT_STAMINA;
        [self saveData:@(self.staminaCapacity) forKey:@"staminaCapacity"];
    } else {
        self.staminaCapacity = [[[NSUserDefaults standardUserDefaults] objectForKey:@"staminaCapacity"] integerValue];
    }
    
    // Stamina Capacity
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stamina"] == nil) {
        self.stamina = self.staminaCapacity;
        [self saveData:@(self.stamina) forKey:@"stamina"];
    } else {
        self.stamina = [[[NSUserDefaults standardUserDefaults] objectForKey:@"stamina"] integerValue];
    }
}

- (void)incrementStaminaCapacity:(long long)stamina {
    self.staminaCapacity += stamina;

    [self saveData:@(self.staminaCapacity) forKey:@"staminaCapacity"];
}

- (void)incrementStamina:(long long)stamina {
    self.stamina += stamina;

    if (self.stamina > self.staminaCapacity) {
        self.stamina = self.staminaCapacity;
    }
    
    [self saveData:@(self.stamina) forKey:@"stamina"];
}

- (void)decrementStamina:(long long)stamina {
    self.stamina -= stamina;
    
    if (self.stamina <= 0) {
        self.stamina = 0;
    }
    
    [self saveData:@(self.stamina) forKey:@"stamina"];
}

- (void)refillStamina {
    self.stamina = self.staminaCapacity;
    [self saveData:@(self.stamina) forKey:@"stamina"];
}

- (float)formatPercentageStamina {
    return (float)self.stamina / (float)self.staminaCapacity;
}

- (BOOL)hasCoin:(long long)coin {
    return self.coin >= coin;
}

- (void)incrementCoin:(long long)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin += coin;
    
    [self saveData:@(self.coin) forKey:@"coin"];
}

- (void)decrementCoin:(long long)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin -= coin;
    
    [self saveData:@(self.coin) forKey:@"coin"];
}


- (void)saveData:(NSObject *)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

@end
