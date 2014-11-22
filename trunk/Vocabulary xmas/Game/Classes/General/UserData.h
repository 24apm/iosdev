//
//  UserData.h
//  NumberGame
//
//  Created by MacCoder on 2/26/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameConstants.h"
#import "VocabularyObject.h"


extern NSString *const UserDataHouseDataChangedNotification;

@interface UserData : NSObject

+ (UserData *)instance;

- (BOOL)hasCoin:(long long)coin;
- (void)incrementCoin:(long long)coin;
- (void)decrementCoin:(long long)coin;

- (void)decrementRetry;
- (void)refillRetry;
- (BOOL)hasRetry;
- (void)incrementCurrentLevel;

- (void)updateDictionaryWith:(NSString *)newVocabulary;
- (void)refillRetryByOne ;
- (void)resetUserDefaults;

- (BOOL)hasVocabFound:(NSString *)newVocabulary;


// unseen words
- (void)addUnseenWord:(NSString *)word;
- (void)removeUnseenWord:(NSString *)word;
- (NSInteger)unseenWordCount;
- (void)retryRefillStartAt:(double)time;

- (BOOL)isTutorial;

@property (nonatomic) long long coin;
@property (strong, nonatomic) NSMutableArray *pokedex;
@property (strong, nonatomic) NSMutableDictionary *unseenWords;

@property (nonatomic) NSInteger currentLevel;

@property (nonatomic) NSInteger retry;
@property (nonatomic) NSInteger retryCapacity;
@property (nonatomic) double retryTime;

@end
