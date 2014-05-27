//
//  BucketView.m
//  Clicker
//
//  Created by MacCoder on 5/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BucketView.h"

@interface BucketView ()
@property (nonatomic) NSTimer *timer;
@end

@implementation BucketView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show {
    [super show];
    [self initialize];
}

- (void)initialize {
    [self imageState];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f/UPDATE_TIME_PER_TICK target:self selector:@selector(updateBar) userInfo:nil repeats:YES];
}

- (void)imageState {
    if ([UserData instance].bucketIsFull) {
        self.bucketImage.image = [UIImage imageNamed:@"tier2"];
    } else {
        self.bucketImage.image = [UIImage imageNamed:@"tier1"];
    }
}

- (void)updateBar {
    if (![UserData instance].bucketIsFull) {
        double percentage = 1 - (([UserData instance].bucketFullTime - CURRENT_TIME) / [UserData instance].currentBucketWaitTime);
        [self.progressBar fillBar:percentage];
        [self imageState];
    } else {
        [self imageState];
        [self.progressBar fillBar:100.f];
    }
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dismissed:sender];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissed:self];
}

- (IBAction)bucketPressed:(id)sender {
    if ([UserData instance].bucketIsFull) {
        [[UserData instance] addOfflineScore];
        [[UserData instance] renewBucketFullTime];
        [self animateLabel:[UserData instance].offlinePoints];
    }
    
}

- (void)animateLabel:(int)value {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self.bucketImage addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%d", value];
    label.center = CGPointMake(self.bucketImage.bounds.size.width / 2, self.bucketImage.bounds.size.height / 2);
    [label animate];
}

@end
