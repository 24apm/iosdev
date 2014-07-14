//
//  BuyerVisitorDialogView.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"
#import "BuyerVisitorData.h"

@interface BuyerVisitorDialogView : AnimatingDialogView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) BuyerVisitorData *data;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;

- (id)initWithData:(BuyerVisitorData *)data;

- (IBAction)noPressed:(id)sender;
- (IBAction)yesButton:(id)sender;

@end
