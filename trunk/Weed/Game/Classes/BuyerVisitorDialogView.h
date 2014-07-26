//
//  BuyerVisitorDialogView.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"
#import "BuyerVisitorData.h"
#import "ConfirmDialogView.h"

@interface BuyerVisitorDialogView : ConfirmDialogView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) BuyerVisitorData *data;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) IBOutlet UILabel *offeredPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *purchasedPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *coinLabel;
- (id)initWithData:(BuyerVisitorData *)data;

@end
