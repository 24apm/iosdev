//
//  ViewController.h
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewControllerBase.h"
#import "ResultView.h"
#import "THLabel.h"
#import "MainView.h"

typedef enum {
    GameStateMainMode,
    GameStateTutorialMode,
    GameStateGameMode,
    GameStateResultMode,
    GameStateShowAnswerMode,
    GameStateShowAchievementMode,
    GameStatePauseMode,
    GameStateResumeMode,
    GameStateGameplayMode,
    GameStateLocalLeaderBoardMode,
    GameStateCustomizeMode
} GameState;

@interface GameViewController : GameViewControllerBase

@property (nonatomic) GameState currentGameState;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
