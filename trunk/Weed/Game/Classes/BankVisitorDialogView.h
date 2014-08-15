//
//  BankVisitorDataView.h
//  Weed
//
//  Created by MacCoder on 8/7/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//


#import "AnimatingDialogView.h"
#import "BankVisitorData.h"
#import "ConfirmDialogView.h"

@interface BankVisitorDialogView : ConfirmDialogView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) RealEstateVisitorData *data;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinLabel;

- (id)initWithData:(BankVisitorData *)data;
@end
