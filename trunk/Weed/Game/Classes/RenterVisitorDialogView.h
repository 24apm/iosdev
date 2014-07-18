//
//  RenterVisitorDialogView.h
//  Weed
//
//  Created by MacCoder on 7/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"
#import "RenterVisitorData.h"

@interface RenterVisitorDialogView : AnimatingDialogView

@property (strong, nonatomic) RenterVisitorData *data;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *rentRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *requirementLabel;

- (IBAction)noPressed:(id)sender;
- (IBAction)yesButton:(id)sender;
- (id)initWithData:(RenterVisitorData *)data;

@end
