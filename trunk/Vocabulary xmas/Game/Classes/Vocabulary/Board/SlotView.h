//
//  SlotView.h
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "LabelBase.h"

@interface SlotView : XibView

@property (strong, nonatomic) IBOutlet LabelBase *labelView;

- (void)animateLabelSelection;

@end
