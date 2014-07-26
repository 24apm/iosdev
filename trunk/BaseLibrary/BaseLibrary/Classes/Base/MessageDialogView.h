//
//  MessageDialogView.h
//  Weed
//
//  Created by MacCoder on 7/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"

@interface MessageDialogView : AnimatingDialogView

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;


- (id)initWithHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText;

@end
