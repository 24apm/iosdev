//
//  LevelManager.h
//  Weed
//
//  Created by MacCoder on 7/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelManager : NSObject

+ (LevelManager *)instance;


// House
- (int)generateHouseSize;
- (long long)generateHouseCost:(int)houseSize;

// Renter
- (int)generateRenterCount;
- (long long)generateRenterDuration;
- (long long)generateRenterRate:(int)count duration:(long long)duration;

@end
