//
//  ViewController.h
//  NumberGame
//
//  Created by MacCoder on 2/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
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
    GameStateResumeMode
} GameState;

@interface GameViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic) GameState currentGameState;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, retain) ADBannerView *adBannerView;

@end
