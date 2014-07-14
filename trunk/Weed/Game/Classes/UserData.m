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

#define NEW_USER_COIN 10

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
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] == nil) {
            self.coin = 10;
            [self saveUserCoin];
        }
        
        [self retrieveUserData];

    }
    return self;
}

- (void)retrieveUserData {
    self.coin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coin"] integerValue];
}

- (void)saveUserCoin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.coin) forKey:@"coin"];
    [defaults synchronize];
}

- (void)incrementCoin:(int)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin += coin;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.coin) forKey:@"coin"];
    [defaults synchronize];
}

- (void)decrementCoin:(int)coin {
    if (self.coin <= 0) {
        self.coin = 0;
    }
    
    self.coin -= coin;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.coin) forKey:@"coin"];
    [defaults synchronize];
}

@end
