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
#import "AnimatedLabel.h"
#import "ConfirmDialogView.h"

NSString *const kHouseViewCollectedNotification = @"kHouseViewCollectedNotification";

@interface HouseView()

@end

@implementation HouseView

- (void)setupWithData:(HouseData *)data {
    self.data = data;
    
    [self refresh];
    
    self.idLabel.text = [NSString stringWithFormat:@"%d", self.data.id];
    self.rentalRateLabel.text = [NSString stringWithFormat:@"$%lld per %@", data.renterData.cost, [Utils formatTime:data.renterData.duration]];
    
    self.personView.image = [UIImage imageNamed:
                             data.renterData.imagePath];
    self.houseSizeLabel.text = [NSString stringWithFormat:@"%d", data.unitSize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:DRAW_STEP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayMessageForNewHouse) name:VIEWING_NEW_HOUSE_NOTIFICATION object:nil];
}

- (void)displayMessageForNewHouse {
    [self animateLabelWithStringNew:@"Congratulation: New house"];
}

- (void)refresh {
    double timeLeft = self.data.renterData.timeDue - CURRENT_TIME;
    double percentage = 1.f - timeLeft / self.data.renterData.duration;
    
    self.alpha = 1.0f;
    self.emptyView.hidden = YES;
    self.inProgressView.hidden = YES;
    self.completedView.hidden = YES;
    self.occupiedView.hidden = YES;
    self.personView.hidden = YES;
    [self.buttonView setBackgroundImage:[[RealEstateManager instance] imageForHouseUnitSize:self.data.unitSize tinted:NO] forState:UIControlStateNormal];
    
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
            if ([RealEstateManager instance].currentRenterData.renterData.count > self.data.unitSize) {
                self.alpha = 0.5f;
            } else {
                self.alpha = 1.0f;
            }
            
            if (self.data.renterData) {
                self.state = HouseViewStateOccupied;
            } else {
                self.state = HouseViewStateEmpty;
            }
            break;
        default:
            break;
    }
    
    
    switch (self.state) {
        case HouseViewStateEmpty:
            self.emptyView.hidden = NO;
            self.rentalRateLabel.text = @"Empty";
            [self.buttonView setBackgroundImage:[[RealEstateManager instance] imageForHouseUnitSize:self.data.unitSize tinted:YES] forState:UIControlStateNormal];
            break;
        case HouseViewStateOccupied:
            self.occupiedView.hidden = NO;
            self.personView.hidden = NO;
            break;
        case HouseViewStateInProgress:
            self.inProgressView.hidden = NO;
            percentage = CLAMP(percentage, 0, 1.f);
            [self.progressBar fillBar:percentage];
            self.timeLabel.text = [Utils formatTime:timeLeft + 1];
            self.personView.hidden = NO;
            break;
        case HouseViewStateCompleted:
            self.completedView.hidden = NO;
            self.personView.hidden = NO;
            break;
        default:
            break;
    }
}

- (IBAction)buttonPressed:(id)sender {
    if (self.hidden) return;
    
    switch (self.state) {
        case HouseViewStateEmpty:
            if ([RealEstateManager instance].state == RealEstateManagerStateEdit) {
                [self confirmAddRenter];
                [self animateLabelWithStringIn:@"Moving in!"];
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
            break;
        case HouseViewStateCompleted:
            if ([[RealEstateManager instance] canCollectMoney:self.data]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kHouseViewCollectedNotification object:self];
                [[RealEstateManager instance] collectMoney:self.data];
                if ([[RealEstateManager instance] hasRenterContractExpired:self.data]) {
                    [self animateLabelWithStringOut:@"Moving out!"];
                    [[RealEstateManager instance] removeRenter:self.data];
                }
            }
            break;
        default:
            break;
    }
}

- (void)animateLabelWithStringIn:(NSString *)string {
    [self.layer removeAllAnimations];
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    label.label.text = string;
    label.center = self.center;
    [label animateSlow];
}

- (void)animateLabelWithStringOut:(NSString *)string {
    [self.layer removeAllAnimations];
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f];
    label.label.text = string;
    label.center = self.center;
    [label animateSlow];
}

- (void)animateLabelWithStringNew:(NSString *)string {
    [self.layer removeAllAnimations];
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.textColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    label.label.text = string;
    label.center = self.center;
    [label animateSlow];
}

- (void)confirmAddRenter {
    if ([[RealEstateManager instance] addRenter:self.data]) {
        [RealEstateManager instance].state = RealEstateManagerStateNormal;
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:HOUSE_RENTER_HOUSE_NOT_LARGE_ENOUGH_HEADER
                                              bodyText:HOUSE_RENTER_HOUSE_NOT_LARGE_ENOUGH_MESSAGE] show];
    }
}

- (void)cleanedUp {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
