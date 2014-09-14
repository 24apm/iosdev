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
#import "GameConstants.h"

@implementation RenterVisitorDialogView

- (id)initWithData:(RenterVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.rentRateLabel.text = [NSString stringWithFormat:@"Rent: $%lld per %@", data.renterData.cost, [Utils formatTime:data.renterData.duration]];
        self.requirementLabel.text = [NSString stringWithFormat: @"Looking for %d room(s)", data.renterData.count];
        self.personFace.image = [UIImage imageNamed:data.imagePath];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:CONFIRMED_RENTER_NOTIFICATION object:[NSNumber numberWithInt:self.data.gender]];
    [RealEstateManager instance].currentRenterData = self.data;
    [RealEstateManager instance].state = RealEstateManagerStateEdit;
    [self yesCallback];
    [self dismissed:sender];
}


@end
