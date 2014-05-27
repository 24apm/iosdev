//
//  UnitView.h
//  Evolution
//
//  Created by MacCoder on 5/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

#define UNIT_VIEW_TAPPED @"UNIT_VIEW_TAPPED"

@interface UnitView : XibView

@property (nonatomic) CGPoint targetPosition;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) CGFloat startTime;

- (void)step;
- (void)generateTarget;

@end
