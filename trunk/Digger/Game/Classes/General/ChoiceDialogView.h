//
//  ChoiceDialogView.h
//  Digger
//
//  Created by MacCoder on 10/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ConfirmDialogView.h"

@interface ChoiceDialogView : ConfirmDialogView
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;

@end
