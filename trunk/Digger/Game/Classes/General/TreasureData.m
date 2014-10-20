//
//  TreasureData.m
//  Digger
//
//  Created by MacCoder on 10/9/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "TreasureData.h"

@implementation TreasureData

- (TreasureData *)setupItemWithRank:(NSUInteger)rank {
    NSArray *currentItemData = [self lookUpTableForRank:rank];
    self.name = [currentItemData objectAtIndex:0];
    self.icon = [currentItemData objectAtIndex:1];
    self.descriptionLabel = [currentItemData objectAtIndex:2];
    self.rank = rank;
    return self;
}

- (NSMutableArray *)lookUpTableForRank:(NSUInteger)rank {
    NSMutableArray *data = [NSMutableArray array];
    NSString *name = @"name";
    NSString *icon = @"gloweffect";
    NSString *descriptionLabel = @"Item";
    
    switch (rank) {
        case 0:
            name = @"item0";
            icon = @"gloweffect";
            descriptionLabel = @"Item #0";
            break;
        case 1:
            name = @"item1";
            icon = @"coin";
            descriptionLabel = @"Item #1";
            break;
        case 2:
            name = @"item2";
            icon = @"bagmoney";
            descriptionLabel = @"Item #2";
            break;
        case 3:
            name = @"item3";
            icon = @"casemoney";
            descriptionLabel = @"Item #3";
            break;
        case 4:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 5:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 6:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 7:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 8:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 9:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 10:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 11:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 12:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 13:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 14:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 15:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 16:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 17:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
        case 18:
            name = @"name";
            icon = @"gloweffect";
            descriptionLabel = @"Item";
            break;
            
        default:
            break;
    }
    
    [data addObject:name];
    [data addObject:icon];
    [data addObject:descriptionLabel];
    return data;
}
@end
