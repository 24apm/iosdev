//
//  PeopleData.h
//  Weed
//
//  Created by MacCoder on 8/22/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface PeopleData : NSObject

+ (NSString *)generateFace:(Gender)gender;
+ (NSString *)randomName:(Gender)gender;
+ (NSNumber *)randomGender;
+ (NSString *)randomJob;

@end
