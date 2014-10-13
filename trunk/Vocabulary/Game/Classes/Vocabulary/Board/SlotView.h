//
//  SlotView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface SlotView : XibView

@property (strong, nonatomic) IBOutlet UILabel *labelView;

- (void)animateLabelSelection;

@end
