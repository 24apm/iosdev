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
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    if ([[RealEstateManager instance] purchaseHouse:self.data.houseData]) {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_REAL_ESTATE_SUCCESS_HEADER bodyText:VISITOR_REAL_ESTATE_SUCCESS_MESSAGE] show];
        [self dismissed:sender];
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_REAL_ESTATE_FAILED_HEADER bodyText:VISITOR_REAL_ESTATE_FAILED_MESSAGE] show];
    }
}

@end
