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
#import "CAEmitterHelperLayer.h"

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
    
//    self.diggerView = [[DiggerView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.diggerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.diggerView.frame = CGRectMake(0,
                                       self.adBannerView.height,
                                       self.view.width,
                                       self.view.height - self.adBannerView.height);
    
//    [self.diggerView setup];
    [self readFile];
}

- (void)readFile {
//    NSString* content = [NSString stringWithContentsOfFile:@"vocabulary.txt"
//                                                  encoding:NSUTF8StringEncoding
    //                                                     error:NULL];
    //    NSLog(@"%@",content);
    
    
    NSString *tmp;
    NSArray *lines;
    NSError *error;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    lines = [content componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    NSMutableArray *entries = [NSMutableArray array];
    
    NSMutableDictionary *vocabGroups = [NSMutableDictionary dictionary];

    while(tmp = [nse nextObject]) {
        
        // replace ":" with ","
        NSMutableArray *vocab = [NSMutableArray arrayWithArray:[tmp componentsSeparatedByString:@","]];
        for (int i = 0; i < vocab.count; i++) {
            vocab[i] = [vocab[i] stringByReplacingOccurrencesOfString:@":" withString:@","];
        }
        
        // "palliate, palliative" -> "palliate"
        NSMutableArray *word = [NSMutableArray arrayWithArray:[vocab[1] componentsSeparatedByString:@","]];
        vocab[1] = word[0];
        
        // Array version
        [entries addObject:vocab];
        
        // Dictionary version
        NSMutableArray *vocabGroup = [vocabGroups objectForKey:vocab[3]];
        if (vocabGroup == nil) {
            vocabGroup = [NSMutableArray array];
            [vocabGroups setObject:vocabGroup forKey:vocab[3]];
        }
        [vocabGroup addObject:vocab];
    }
    
    for (NSString *key in [vocabGroups allKeys]) {
        NSLog(@"%@ %d", key, [[vocabGroups objectForKey:key] count]);
    }
    NSLog(@"%@", vocabGroups);

    NSLog(@"%@", entries);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
