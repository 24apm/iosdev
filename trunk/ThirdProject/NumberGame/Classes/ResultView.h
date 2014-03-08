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

@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxScoreLabel;
@property (nonatomic) int lastMaxScore;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;
@property (strong, nonatomic) IBOutlet UILabel *reachedLabel;

@property (strong, nonatomic) IBOutlet UILabel *targetAnswerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *answerImage;
@property (strong, nonatomic) UIViewController *vc;
@property (strong, nonatomic) NSString *sharedText;
@property (strong, nonatomic) UIImage *sharedImage;
@property (strong, nonatomic) IBOutlet UILabel *recordLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lastGameSS;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *unlockButton;
@property (strong, nonatomic) IBOutlet UIView *fadeOverlay;
@property (strong, nonatomic) IBOutlet UIView *animatedView;

- (void)show;

@end
