//
//  LocalLeaderBoardView.h
//  SequenceGame
//
//  Created by MacCoder on 3/15/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XibView.h"

#define RETRY_BUTTON_NOTIFICATION @"RETRY_BUTTON_NOTIFICATION"
#define TOP_BUTTON_NOTIFICATION @"TOP_BUTTON_NOTIFICATION"

@interface LocalLeaderBoardView : XibView

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelScores;

- (void)show;

@end
