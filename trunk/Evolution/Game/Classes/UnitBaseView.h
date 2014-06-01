//
//  UnitBaseView.h
//  Evolution
//
//  Created by MacCoder on 5/31/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

typedef enum {
    UnitViewStateAnimateIdle,
    UnitViewStateIdle,
    UnitViewStateAnimateRunning,
    UnitViewStateRunning
} UnitViewState;

@interface UnitBaseView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *characterImageView;
@property (nonatomic) UnitViewState state;
@property (nonatomic, readonly) CFTimeInterval idleDuration;

- (void)step;
- (void)generateTarget;

// override
- (NSArray *)idleImages;
- (NSArray *)runningImages;
- (void)doPressed;

@end
