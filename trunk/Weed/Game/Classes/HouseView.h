//
//  HouseView.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ProgressBarComponent.h"

typedef enum {
    HouseViewStateEmpty,
    HouseViewStateInProgress,
    HouseViewStateCompleted
} HouseViewState;

@interface HouseView : XibView

@property (strong, nonatomic) IBOutlet UIView *inProgressView;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *progressBar;

@property (strong, nonatomic) IBOutlet UIView *completedView;

@property (nonatomic) HouseViewState state;

- (void)setup;

@end
