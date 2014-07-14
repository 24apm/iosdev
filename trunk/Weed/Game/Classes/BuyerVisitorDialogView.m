//
//  BuyerVisitorDialogView.m
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BuyerVisitorDialogView.h"
#import "ErrorDialogView.h"
#import "RealEstateManager.h"

@implementation BuyerVisitorDialogView

- (id)initWithData:(BuyerVisitorData *)data {
    self = [super init];
    if (self) {
        self.data = data;
        self.nameLabel.text = data.name;
        self.occupationLabel.text = data.occupation;
        self.costLabel.text = [NSString stringWithFormat:@"%lld", data.houseData.cost ];
        self.idLabel.text = [NSString stringWithFormat:@"%d", self.data.houseData.id];
        self.imageView.image = [UIImage imageNamed:data.houseData.imagePath];
    }
    return self;
}

- (IBAction)noPressed:(id)sender {
    [self dismissed:sender];
}

- (IBAction)yesButton:(id)sender {
    [[RealEstateManager instance] sellHouse:self.data.houseData];
    [self dismissed:sender];
}

@end
