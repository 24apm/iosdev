//
//  GameLayoutView.h
//  SequenceGame
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "BoardView.h"

@interface GameLayoutView : XibView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet BoardView *boardView;
@property (strong, nonatomic) IBOutlet UILabel *currentScore;

- (void)generateNewBoard;

@end
