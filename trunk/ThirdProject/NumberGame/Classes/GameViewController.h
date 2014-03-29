//
//  ViewController.h
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultView.h"
#import "THLabel.h"
#import "MainView.h"
#import "GameViewControllerBase.h"

typedef enum {
    GameStateMainMode,
    GameStateTutorialMode,
    GameStateGameMode,
    GameStateResultMode,
    GameStateShowAnswerMode,
    GameStateShowAchievementMode,
    GameStatePauseMode,
    GameStateResumeMode
} GameState;

@interface GameViewController : GameViewControllerBase

@property (nonatomic) GameState currentGameState;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
