//
//  RenterVisitorDialogView.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RenterVisitorDialogView.h"
#import "Utils.h"
#import "RealEstateManager.h"

@implementation RenterVisitorDialogView

- (id)initWithData:(RenterVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.rentRateLabel.text = [NSString stringWithFormat:@"Rent: $%lld per %@", data.renterData.cost, [Utils formatTime:data.renterData.duration]];
        self.requirementLabel.text = [NSString stringWithFormat: @"Looking for %d room(s)", data.renterData.count];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    [RealEstateManager instance].currentRenterData = self.data;
    [RealEstateManager instance].state = RealEstateManagerStateEdit;
    [self dismissed:sender];
}


@end
