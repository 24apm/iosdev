//
//  VocabularyTableDialogView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyTableDialogView.h"
#import "VocabularyManager.h"
#import "VocabularyTableView.h"
#import "UserData.h"
#import "GameCenterHelper.h"

@interface VocabularyTableDialogView()

@property (nonatomic, strong) NSDictionary *unseenWords;

@end

@implementation VocabularyTableDialogView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)[VocabularyManager instance].currentCount, (long)[VocabularyManager instance].maxCount];
        self.unseenWords = [[UserData instance].unseenWords copy];
    }
    return self;
}

#pragma mark - mixed
- (IBAction)sectionPressed:(id)sender {
}

#pragma mark - all vocabulary
- (IBAction)vocabularyPressed:(id)sender {
}

- (IBAction)leaderboardPressed:(id)sender {
    [[GameCenterHelper instance] showLeaderboard:[Utils rootViewController]];
}

#pragma mark - reset
- (IBAction)resetPressed:(id)sender {
    [[UserData instance] resetUserDefaults];
    [self dismissed:self];
}

- (void)dismissed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VocabularyTableDialogViewDimissed object:nil];
    [super dismissed:sender];
}

@end
