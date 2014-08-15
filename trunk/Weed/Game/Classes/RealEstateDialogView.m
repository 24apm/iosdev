//
//  RealEstateDialogView.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RealEstateDialogView.h"
#import "RealEstateManager.h"
#import "MessageDialogView.h"
#import "AppString.h"
#import "UserData.h"
#import "AnimatedLabel.h"

@implementation RealEstateDialogView

- (id)initWithData:(RealEstateVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.costLabel.text = [NSString stringWithFormat:@"$%lld", data.houseData.cost];
        self.imageView.image = [UIImage imageNamed:[[RealEstateManager instance] imageForHouseUnitSize:data.houseData.unitSize]];
        self.roomCountLabel.text = [NSString stringWithFormat:@"%d", self.data.houseData.unitSize];
        self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    if (![[RealEstateManager instance] canPurchaseHouseWithHouseLimit:self.data.houseData]) {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_REAL_ESTATE_FAILED_HOUSE_LIMIT_HEADER
                                              bodyText:VISITOR_REAL_ESTATE_FAILED_HOUSE_LIMIT_MESSAGE] show];
        return;
    }
    
    if (![[RealEstateManager instance] canPurchaseHouseWithMoney:self.data.houseData]) {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_REAL_ESTATE_FAILED_MONEY_HEADER
                                              bodyText:VISITOR_REAL_ESTATE_FAILED_MONEY_MESSAGE] show];
        return;
    }
    
    if ([[RealEstateManager instance] purchaseHouse:self.data.houseData]) {
//        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_REAL_ESTATE_SUCCESS_HEADER bodyText:VISITOR_REAL_ESTATE_SUCCESS_MESSAGE] show];
       // [self animateLabelWithString:@"NEW HOUSE PURCHASED"];
        [[NSNotificationCenter defaultCenter]postNotificationName:PURCHASED_HOUSE_NOTIFICATION object:nil];
        [self dismissed:sender];
        [self yesCallback];
    }
}

- (void)animateLabelWithString:(NSString *)string {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:0.f green:1.f blue:1.f alpha:1.f];
    label.label.text = string;
    label.center = self.center;
    [label animateSlow];
}
@end
