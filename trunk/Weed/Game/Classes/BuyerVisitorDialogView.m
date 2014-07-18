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

@implementation BuyerVisitorDialogView

- (id)initWithData:(BuyerVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.costLabel.text = [NSString stringWithFormat:@"%@ is bidding $%d for your house! You purchased it for $%lld. Are you willing to accept the offer?", data.name, [self.data buyerPrice], data.houseData.cost];
        self.idLabel.text = [NSString stringWithFormat:@"%d", self.data.houseData.id];
        self.imageView.image = [UIImage imageNamed:[[RealEstateManager instance] imageForHouseUnitSize:data.houseData.unitSize]];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    if ([[RealEstateManager instance] canSellHouse:self.data.houseData]) {
        [[RealEstateManager instance] sellHouse:self.data.houseData buyerPrice:[self.data buyerPrice]];
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_BUYER_SUCCESS_HEADER bodyText:VISITOR_BUYER_SUCCESS_MESSAGE] show];

    } else {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_BUYER_FAILED_HEADER bodyText:VISITOR_BUYER_FAILED_MESSAGE] show];

    }
    [self dismissed:sender];
}

@end
