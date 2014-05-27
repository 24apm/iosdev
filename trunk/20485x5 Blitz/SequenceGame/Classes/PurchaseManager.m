//
//  PurchaseManager.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 5/1/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PurchaseManager.h"

@implementation PurchaseManager

+ (PurchaseManager *)instance {
    static PurchaseManager *instance = nil;
    if (!instance) {
        instance = [[PurchaseManager alloc] init];
    }
    return instance;
}

- (BOOL)purchasePowerUp:(PowerUpType)type {
    BOOL validation = NO;
    
    switch (type) {
        case PowerUpTypeShuffle:
            if([UserData instance].currentCoin >= [GameData instance].shuffleCost) {
                [UserData instance].currentCoin = [UserData instance].currentCoin - [GameData instance].shuffleCost;
                [[GameData instance] shuffleCostUpgrade];
                validation = YES;
                [TrackUtils trackAction:@"purchaseShuffle" label:[NSString stringWithFormat:@"%d", [GameData instance].shuffleCost]];
            }
            break;
        case PowerUpTypeBomb2:
            if([UserData instance].currentCoin >= [GameData instance].bomb2Cost) {
                [UserData instance].currentCoin = [UserData instance].currentCoin - [GameData instance].bomb2Cost;
                [[GameData instance] bomb2CostUpgrade];
                validation = YES;
                [TrackUtils trackAction:@"purchaseBomb2" label:[NSString stringWithFormat:@"%d", [GameData instance].bomb2Cost]];

            }
            break;
        case PowerUpTypeBomb4:
            if([UserData instance].currentCoin >= [GameData instance].bomb4Cost) {
                [UserData instance].currentCoin = [UserData instance].currentCoin - [GameData instance].bomb4Cost;
                [[GameData instance] bomb4CostUpgrade];
                validation = YES;
                [TrackUtils trackAction:@"purchaseBomb4" label:[NSString stringWithFormat:@"%d", [GameData instance].bomb4Cost]];
            }
            break;
        case PowerUpTypeRevive:
            if([UserData instance].currentCoin >= [GameData instance].lostGameCost || [GameData instance].lostGameCost <= 0 ) {
                [UserData instance].currentCoin = [UserData instance].currentCoin - [GameData instance].lostGameCost;
                [[GameData instance] lostGameCostUpgrade];
                validation = YES;
                [TrackUtils trackAction:@"purchaseRevive" label:[NSString stringWithFormat:@"%d", [GameData instance].lostGameCost]];
            }
            break;
            
        default:
            break;
    }

    [[UserData instance] saveUserCoin];
    
    if (validation != YES) {
        [[CoinIAPHelper sharedInstance] showCoinMenu];
    }
    return validation;
}

@end