//
//  ConfirmDialogView.h
//  Weed
//
//  Created by MacCoder on 7/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "MessageDialogView.h"
#import "Utils.h"


@interface ConfirmDialogView : MessageDialogView

- (id)initWithHeaderText:(NSString *)headerText
                bodyText:(NSString *)bodyText
              yesPressed:(BLOCK)yesPressed
               noPressed:(BLOCK)noPressed;

- (IBAction)yesPressed:(id)sender;
- (IBAction)noPressed:(id)sender;
- (void)yesCallback;
- (void)noCallback;

@property (nonatomic, copy) BLOCK yesPressedSelector;
@property (nonatomic, copy) BLOCK noPressedSelector;

@end