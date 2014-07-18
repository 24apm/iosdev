//
//  MessageDialogView.m
//  Weed
//
//  Created by MacCoder on 7/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "MessageDialogView.h"

@implementation MessageDialogView

- (id)initWithHeaderText:(NSString *)headerText bodyText:(NSString *)bodyText {
    self = [super init];
    if (self) {
        self.headerLabel.text = headerText;
        self.bodyLabel.text = bodyText;
    }
    return self;
}

@end
