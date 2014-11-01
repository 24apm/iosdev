//
//  FoundWordDialogView.m
//  Vocabulary
//
//  Created by MacCoder on 10/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CompletedLevelDialogView.h"

@interface CompletedLevelDialogView()

@property (nonatomic, strong) BLOCK block;

@end

@implementation CompletedLevelDialogView

- (id)initWithCallback:(BLOCK)callback; {
    self = [super init];
    if (self) {
        self.block = callback;
    }
    return self;
}


- (IBAction)nextPressed:(id)sender {
    self.block();
    [self dismissed:self];
}

@end
