//
//  BuyerVisitorDialogView.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BuyerVisitorDialogView.h"
#import "RealEstateManager.h"
#import "MessageDialogView.h"
#import "AppString.h"
#import "UserData.h"
#import "ConfirmDialogView.h"

@implementation BuyerVisitorDialogView

- (id)initWithData:(BuyerVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;

        long long houseCost = data.houseData.cost;
        int offeredPrice = [self.data buyerPrice];
        
        self.roomLabel.text = [NSString stringWithFormat:@"%d", self.data.houseData.unitSize];
        self.purchasedPriceLabel.text = [NSString stringWithFormat:@"$%lld", houseCost];
        self.offeredPriceLabel.text = [NSString stringWithFormat:@"$%d", offeredPrice];

        if (offeredPrice >= houseCost) {
            self.offeredPriceLabel.textColor = [UIColor greenColor];
        } else {
            self.offeredPriceLabel.textColor = [UIColor redColor];
        }
        
        self.idLabel.text = [NSString stringWithFormat:@"%d", self.data.houseData.id];
        self.imageView.image = [UIImage imageNamed:[[RealEstateManager instance] imageForHouseUnitSize:data.houseData.unitSize]];
        self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];

    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    if ([[RealEstateManager instance] canSellHouse]) {
        [[[ConfirmDialogView alloc] initWithHeaderText:VISITOR_BUYER_CONFIRM_HEADER
                                              bodyText:VISITOR_BUYER_CONFIRM_MESSAGE
                                            yesPressed:^ {
                                                [[RealEstateManager instance] sellHouse:self.data.houseData buyerPrice:[self.data buyerPrice]];
                                                [[[MessageDialogView alloc] initWithHeaderText:VISITOR_BUYER_SUCCESS_HEADER bodyText:VISITOR_BUYER_SUCCESS_MESSAGE] show];
                                                [self dismissed:sender];
                                                [self yesCallback];

                                            } noPressed:nil] show];
        
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_BUYER_FAILED_HEADER bodyText:VISITOR_BUYER_FAILED_MESSAGE] show];
        [self dismissed:sender];
    }
}

@end
