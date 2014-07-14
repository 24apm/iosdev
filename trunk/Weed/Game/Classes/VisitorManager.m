//
//  VisitorManager.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VisitorManager.h"
#import "RealEstateVisitorData.h"
#import "RealEstateDialogView.h"
#import "NSArray+Util.h"
#import "BuyerVisitorDialogView.h"
#import "BuyerVisitorData.h"
#import "UserData.h"

@interface VisitorManager()

@property (strong, nonatomic) NSMutableArray *visitors;

@end

@implementation VisitorManager

+ (VisitorManager *)instance {
    static VisitorManager *instance = nil;
    if (!instance) {
        instance = [[VisitorManager alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.visitors = [NSMutableArray array];
//        [self generateVisitors];
    }
    return self;
}

- (VisitorData *)nextVisitor {
    [self.visitors enqueue:[self generateRandomVisitor]];
    return [self.visitors dequeue];
}

- (void)generateVisitors {
    for (int i = 0; i < 10; i++) {
        [self.visitors enqueue:[self generateRandomVisitor]];
    }
}

- (VisitorData *)generateRandomVisitor {
    // job
    // buyer
    // real estate
    // tenant
    int randVisitor = arc4random() % 2;
    switch (randVisitor) {
        case 0:
            return [self generateRealEstateVisitor];
            break;
        case 1:
            return [self generateBuyerVisitor];
            break;
        default:
            break;
    }
    return [self generateRealEstateVisitor];
}

- (RealEstateVisitorData *)generateRealEstateVisitor {
    RealEstateVisitorData *data = [[RealEstateVisitorData alloc] init];
    data.houseData.cost = 10;
    data.houseData.imagePath = @"House.png";
    data.imagePath = @"ToiletRush120.png";
    data.name = @"Some Seller";
    data.occupation = @"Realtor";
    return data;
}

- (BuyerVisitorData *)generateBuyerVisitor {
    BuyerVisitorData *data = [[BuyerVisitorData alloc] init];
    data.houseData = [[UserData instance] randomUserHouse];
    data.imagePath = @"NGIcon120.png";
    data.name = @"Some Buyer";
    data.occupation = @"Doctor";
    return data;
}


- (XibDialogView *)dialogFor:(VisitorData *)visitorData {
    if ([visitorData isKindOfClass:[RealEstateVisitorData class]]) {
        return [[RealEstateDialogView alloc] initWithData:(RealEstateVisitorData *)visitorData];
    } else if ([visitorData isKindOfClass:[BuyerVisitorData class]]) {
        return [[BuyerVisitorDialogView alloc] initWithData:(BuyerVisitorData *)visitorData];
    }
    return nil;
}

@end
