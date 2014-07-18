//
//  HouseView.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "HouseView.h"
#import "Utils.h"
#import "GameLoopTimer.h"
#import "UserData.h"
#import "Utils.h"
#import "RealEstateManager.h"
#import "MessageDialogView.h"
#import "AppString.h"
#import "ConfirmDialogView.h"

@interface HouseView()

@end

@implementation HouseView

- (void)setupWithData:(HouseData *)data {
    self.data = data;
    
    [self refresh];
    
    self.idLabel.text = [NSString stringWithFormat:@"%d", self.data.id];
    
    [self.buttonView setBackgroundImage:[UIImage imageNamed:self.data.imagePath] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:DRAW_STEP_NOTIFICATION object:nil];
}

- (void)refresh {
    double timeLeft = self.data.renterData.timeDue - CURRENT_TIME;
    double percentage = 1.f - timeLeft / self.data.renterData.duration;
    
    switch ([RealEstateManager instance].state) {
        // NORMAL Mode
        case RealEstateManagerStateNormal:
            // has renter
            if (self.data.renterData) {
                if (percentage < 1.f) {
                    self.state = HouseViewStateInProgress;
                } else {
                    self.state = HouseViewStateCompleted;
                }
            } else {
                self.state = HouseViewStateEmpty;
            }
            break;
        // EDIT Mode
        case RealEstateManagerStateEdit:
            if (self.data.renterData) {
                self.state = HouseViewStateOccupied;
            } else {
                self.state = HouseViewStateEmpty;
            }
            break;
        default:
            break;
    }
    
    self.emptyView.hidden = YES;
    self.inProgressView.hidden = YES;
    self.completedView.hidden = YES;
    self.occupiedView.hidden = YES;
   
    switch (self.state) {
        case HouseViewStateEmpty:
            self.emptyView.hidden = NO;
            break;
        case HouseViewStateOccupied:
            self.occupiedView.hidden = NO;
            break;
        case HouseViewStateInProgress:
            self.inProgressView.hidden = NO;
            percentage = CLAMP(percentage, 0, 1.f);
            [self.progressBar fillBar:percentage];
            self.timeLabel.text = [Utils formatTime:timeLeft];
            break;
        case HouseViewStateCompleted:
            self.completedView.hidden = NO;
            break;
        default:
            break;
    }
}

- (IBAction)buttonPressed:(id)sender {
    switch (self.state) {
        case HouseViewStateEmpty:
            if ([RealEstateManager instance].state == RealEstateManagerStateEdit) {
                [self confirmAddRenter];
                [[[MessageDialogView alloc] initWithHeaderText:HOUSE_RENTER_ADDED_HEADER
                                                      bodyText:HOUSE_RENTER_ADDED_MESSAGE] show];
            } else {
                [[[MessageDialogView alloc] initWithHeaderText:HOUSE_EMPTY_HEADER
                                                      bodyText:HOUSE_EMPTY_MESSAGE] show];
            }
            break;
        case HouseViewStateOccupied:
            if ([RealEstateManager instance].state == RealEstateManagerStateEdit) {
                [[[ConfirmDialogView alloc] initWithHeaderText:HOUSE_RENTER_REPLACE_HEADER
                                                      bodyText:HOUSE_RENTER_REPLACE_MESSAGE
                                                    yesPressed:^ {
                                                        [self confirmAddRenter];
                                                    }
                                                     noPressed:nil] show];
            } else {
                [[[ConfirmDialogView alloc] initWithHeaderText:HOUSE_EMPTY_HEADER
                                                      bodyText:HOUSE_EMPTY_MESSAGE] show];
            }
            break;
        case HouseViewStateInProgress:
            [[[MessageDialogView alloc] initWithHeaderText:HOUSE_COLLECT_FAILED_HEADER
                                                  bodyText:HOUSE_COLLECT_FAILED_MESSAGE] show];
            break;
        case HouseViewStateCompleted:
            [[RealEstateManager instance] collectMoney:self.data];
            break;
        default:
            break;
    }
}

- (void)confirmAddRenter {
    [[RealEstateManager instance] addRenter:self.data];
    [RealEstateManager instance].state = RealEstateManagerStateNormal;
}

- (void)removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

@end
