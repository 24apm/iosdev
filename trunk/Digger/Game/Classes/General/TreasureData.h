//
//  TreasureData.h
//  Digger
//
//  Created by MacCoder on 10/9/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreasureData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *descriptionLabel;
@property (nonatomic) NSUInteger rank;
- (TreasureData *)setupItemWithRank:(NSUInteger)rank;
    
@end
