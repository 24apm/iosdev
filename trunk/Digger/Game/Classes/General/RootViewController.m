//
//  RootViewController.m
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "RootViewController.h"
#import "SoundManager.h"
#import "CustomGameLoopTimer.h"
#import "GameConstants.h"
#import "GameCenterHelper.h"

@interface RootViewController ()

@property (strong, nonatomic) DiggerView *diggerView;
@property (strong, nonatomic) NSArray *products;

@end

@implementation RootViewController

- (AdBannerPositionMode)adBannerPositionMode {
    return AdBannerPositionModeTop;
}

- (void)preloadSounds {
    [[SoundManager instance] prepare:SOUND_EFFECT_TICKING count:1];
    [[SoundManager instance] prepare:SOUND_EFFECT_WINNING count:3];
    [[SoundManager instance] prepare:SOUND_EFFECT_BOING count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_POP count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_BLING count:5];
    [[SoundManager instance] prepare:SOUND_EFFECT_DUING count:3];
    [[SoundManager instance] prepare:SOUND_EFFECT_CLANG count:3];
    [[SoundManager instance] prepare:SOUND_EFFECT_BOILING count:3];
    [[SoundManager instance] prepare:SOUND_EFFECT_BUI count:3];
    [[SoundManager instance] prepare:SOUND_EFFECT_ANVIL count:3];
    [[SoundManager instance] prepare:SOUND_EFFECT_HALLELUJAH count:2];
    [[SoundManager instance] prepare:SOUND_EFFECT_GUINEA count:8];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CustomGameLoopTimer instance] initialize];
    
    [self preloadSounds];
    [GameCenterHelper instance].currentLeaderBoard = kLeaderboardBestScoreID;
    [[GameCenterHelper instance] loginToGameCenter];
    
    self.diggerView = [[DiggerView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.diggerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.diggerView.frame = CGRectMake(0,
                                       self.adBannerView.height,
                                       self.view.width,
                                       self.view.height - self.adBannerView.height);
    
    [self.diggerView setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
