//
//  RenterVisitorDialogView.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RenterVisitorDialogView.h"
#import "Utils.h"

@implementation RenterVisitorDialogView

- (id)initWithData:(RenterVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.rentRateLabel.text = [NSString stringWithFormat:@"$%lld per %@", data.renterData.cost, [Utils formatTime:data.renterData.duration]];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    [self dismissed:sender];
}


@end
