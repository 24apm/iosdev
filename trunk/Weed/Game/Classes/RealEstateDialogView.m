//
//  RealEstateDialogView.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RealEstateDialogView.h"
#import "RealEstateManager.h"
#import "ErrorDialogView.h"

@implementation RealEstateDialogView

- (id)initWithData:(RealEstateVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.costLabel.text = [NSString stringWithFormat:@"%lld", data.houseData.cost ];
        self.imageView.image = [UIImage imageNamed:data.houseData.imagePath];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    if ([[RealEstateManager instance] purchaseHouse:self.data.houseData]) {
        [self dismissed:sender];
    } else {
        [[[ErrorDialogView alloc] init] show];
    }
}

@end
