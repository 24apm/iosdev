//
//  HouseView.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "ProgressBarComponent.h"
#import "HouseData.h"

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

@property (strong, nonatomic) HouseData *data;
@property (strong, nonatomic) IBOutlet UIButton *buttonView;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;

- (void)setupWithData:(HouseData *)data;

@end
