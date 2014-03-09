//
//  MenuView.h
//  NumberGame
//
//  Created by MacCoder on 2/8/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface MainView : XibView

#define MAIN_VIEW_DISMISSED_NOTIFICATION @"MAIN_VIEW_DISMISSED_NOTIFICATION"
#define SHOW_LEADERBOARD_NOTIFICATION @"SHOW_LEADERBOARD_NOTIFICATION"
#define SHOW_ACHIEVEMENT_NOTIFICATION @"SHOW_ACHIEVEMENT_NOTIFICATION"

@property (strong, nonatomic) IBOutlet UIButton *resetButton;

- (void)show;

@end
