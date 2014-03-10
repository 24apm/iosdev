//
//  ResultView.h
//  NumberGame
//
//  Created by MacCoder on 2/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

#define RESULT_VIEW_DISMISSED_NOTIFICATION @"RESULT_VIEW_DISMISSED_NOTIFICATION"
#define RESULT_VIEW_SHOW_ANSWER_NOTIFICATION @"RESULT_VIEW_SHOW_ANSWER_NOTIFICATION"
#define RESULT_VIEW_SHOW_ACHIEVEMENT_NOTIFICATION @"RESULT_VIEW_SHOW_ACHIEVEMENT_NOTIFICATION"

@interface ResultView : XibView

@property (nonatomic) int lastMaxScore;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;

@property (strong, nonatomic) IBOutlet UIView *fadeOverlay;
@property (strong, nonatomic) IBOutlet UIView *animatedView;

- (void)show;

@end
