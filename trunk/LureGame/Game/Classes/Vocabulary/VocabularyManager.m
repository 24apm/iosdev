//
//  VocabularyManager.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyManager.h"
#import "NSArray+Util.h"
#import "UserData.h"
#import "Utils.h"
#import "GameCenterHelper.h"
#import "NSString+StringUtils.h"

#define TEXT_FILE @"vocabulary.txt"
#define MIX_TEXT_FILE @"mixvocabulary.txt"
#define EMPTY_SPACE @"_"
#define MAX_STRING_LENGTH 8
#define NUM_OF_WORDS 9
#define WORD_FIT_ATTEMPTS 10
@interface VocabularyManager()

@property (strong, nonatomic) NSMutableDictionary *dictionaryBySection;
@property (strong, nonatomic) NSMutableDictionary *dictionaryByVocab;
@property (strong, nonatomic) NSMutableArray *mixVocabArray;
@property (strong, nonatomic) NSDictionary *vocabSectionsToIndexes;
@property (strong, nonatomic) NSDictionary *vocabIndexesToSections;
@property (strong, nonatomic) NSDictionary *mixedVocabDictionaryBySection;
@property (nonatomic) BOOL foundNewWord;
@property (nonatomic) NSInteger gamesNoNewWord;
@property (nonatomic) BOOL gameWithNewWords;
@property (nonatomic, strong) NSMutableArray *map;
@property (strong, nonatomic) LevelData *levelData;

@end

@implementation VocabularyManager

+ (VocabularyManager *)instance {
    static VocabularyManager *instance = nil;
    if (!instance) {
        instance = [[VocabularyManager alloc] init];
    }
    return instance;
}

- (BOOL)hasUserUnlockedVocab:(NSString *)vocab {
    return [[UserData instance].pokedex containsObject:vocab];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //         self.letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    }
    return self;
}

- (NSDictionary *)vocabList {
    return [NSDictionary dictionaryWithDictionary:self.dictionaryBySection];
}


- (NSString *)definitionForVocab:(NSString *)vocab {
    return [self.dictionaryByVocab objectForKey:vocab];
}

- (VocabularyObject *)vocabObjectForVocab:(NSString *)vocab {
    VocabularyObject *vocabObject = [[VocabularyObject alloc] init];
    vocabObject.word = vocab;
    vocabObject.definition = [self definitionForVocab:vocab];
    return vocabObject;
}

- (NSUInteger)maxCount {
    return self.dictionaryByVocab.count;
}

- (NSUInteger)currentCount {
    return [UserData instance].pokedex.count;
}

- (void)setupMixedDictionary {
    NSMutableDictionary *mixedDictionaryBySection = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < self.vocabSectionsToIndexes.count - 1; i++) {
        NSString *key = [NSString stringWithFormat:@"%ld", (long)i];
        
        NSArray *mixVocabFromLevel = [self mixVocabFromLevel:i toLevel:i+1];
        
        // sort
        NSArray *mixVocabFromLevelSorted = [mixVocabFromLevel sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        [mixedDictionaryBySection setObject:mixVocabFromLevelSorted forKey:key];
    }
    self.mixedVocabDictionaryBySection = mixedDictionaryBySection;
}

- (void)loadFileForMix {
    NSString *row;
    NSArray *lines;
    NSError *error;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:MIX_TEXT_FILE ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    lines = [content componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    self.mixVocabArray = [NSMutableArray array];
    
    while(row = [nse nextObject]) {
        
        NSString *rawWord = row;
        
        if (rawWord.length > MAX_STRING_LENGTH) {
            continue;
        }
        
        [self.mixVocabArray addObject:rawWord];
    }
}



// remove all accents
-(NSString *)removeAccents:(NSString *)word {
    NSData *asciiEncoded = [word dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
    
    // take the data object and recreate a string using the lossy conversion
    return [[NSString alloc] initWithData:asciiEncoded
                                 encoding:NSASCIIStringEncoding];
}

- (VocabularyObject *)vocabObjectForWord:(NSString *)word {
    return [self.dictionaryByVocab objectForKey:word];
}

- (LevelData *)generateLevel {
    [self checkNewWordsFound];
    self.levelData = [[LevelData alloc] init];
    self.levelData.numColumn = NUM_COL;
    self.levelData.numRow = NUM_ROW;

    return self.levelData;
}

- (NSMutableDictionary *)updateLetterDictionary:(NSString *)letter
                                             to:(NSMutableDictionary *)dictionary
                                        withRow:(NSInteger)row
                                        withCol:(NSInteger)col
{
    NSMutableDictionary *tempDictionary = dictionary;
    NSMutableArray *array = [NSMutableArray array];
    if ([tempDictionary objectForKey:letter] != nil) {
        array = [tempDictionary objectForKey:letter];
    }
    [array addObject:[NSNumber numberWithInteger:row]];
    [array addObject:[NSNumber numberWithInteger:col]];
    
    [tempDictionary setObject:array forKey:letter];
    return tempDictionary;
}

- (NSArray *)pointsForLetter:(NSString *)letter with:(NSDictionary *)dictionary {
    NSMutableArray *letterPoints = [dictionary objectForKey:letter];
    return letterPoints;
}

- (NSUInteger)indexForLeveData:(LevelData *)levelData row:(NSUInteger)r column:(NSUInteger)c {
    return r * levelData.numColumn + c;
}

- (CGPoint)directionPointLookUp:(NSInteger)direction {
    CGPoint directionalPoint;
    
    switch (direction) {
            // top right
        case 0: {
            directionalPoint.y = -1;
            directionalPoint.x = 1;
        }
            break;
            // right
        case 1: {
            directionalPoint.y = 0;
            directionalPoint.x = 1;
        }
            break;
            // bottom right
        case 2: {
            directionalPoint.y = 1;
            directionalPoint.x = 1;
        }
            break;
            // bottom
        case 3: {
            directionalPoint.y = 1;
            directionalPoint.x = 0;
        }
            // top left
        case 4: {
            directionalPoint.y = -1;
            directionalPoint.x = -1;
        }
            break;
            // top
        case 5: {
            directionalPoint.y = -1;
            directionalPoint.x = 0;
        }
            break;
            // bottom left
        case 6: {
            directionalPoint.y = 1;
            directionalPoint.x = -1;
        }
            break;
            // left
        case 7: {
            directionalPoint.y = 0;
            directionalPoint.x = -1;
        }
            break;
            
        default:
            break;
    }
    return directionalPoint;
}

- (BOOL)checkSolution:(LevelData *)levelData word:(NSString *)word {
    for (VocabularyObject *vocabData in levelData.vocabularyList) {
        if ([word isEqualToString:vocabData.word]) {
            if (![[UserData instance].pokedex containsObject:word]) {
                self.foundNewWord = YES;
            }
            return YES; // found match
        }
    }
    return NO;
}
- (NSString *)mapToString:(LevelData *)levelData map:(NSArray *)map {
    NSString *string = @"";
    for (NSInteger i = 0; i < levelData.numRow; i++) {
        for (NSInteger j = 0; j < levelData.numColumn; j++) {
            NSString *letter = [self.map objectAtIndex:[self indexForLeveData:levelData row:i column:j]];
            string = [NSString stringWithFormat:@"%@ %@",string,letter];
        }
        string = [string stringByAppendingString:@"\n"];
    }
    return string;
}

- (NSMutableArray *)mixVocabFromLevel:(NSInteger)start toLevel:(NSInteger)end  {
    NSInteger levelStart = [self mixVocabIndexWith:start];
    NSInteger levelEnd = [self mixVocabIndexWith:end];
    NSMutableArray *currentLevelVocab = [NSMutableArray array];
    for (NSInteger i = levelStart; i < levelEnd; i++) {
        [currentLevelVocab addObject:[self.mixVocabArray objectAtIndex:i]];
    }
    return currentLevelVocab;
}

- (NSInteger)unlockedUptoLevel:(NSInteger)wordsFound {
    NSArray *sortedMixedVocabsIndexes = [[self.vocabIndexesToSections allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue]==[obj2 intValue])
            return NSOrderedSame;
        else if ([obj1 intValue]<[obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    
    NSInteger i = 0;
    for (; i < sortedMixedVocabsIndexes.count; i++) {
        NSInteger index = [[sortedMixedVocabsIndexes objectAtIndex:i] integerValue];
        if (wordsFound < index) {
            break;
        }
    }
    return i;
}

- (void)checkNewWordsFound {
    if (!self.foundNewWord) {
        self.gamesNoNewWord++;
    } else {
        self.foundNewWord = NO;
        self.gamesNoNewWord = 0;
    }
    
    if (self.gamesNoNewWord > 1) {
        self.gameWithNewWords = YES;
    } else {
        self.gameWithNewWords = NO;
    }
}

- (NSInteger)mixVocabIndexWith:(NSInteger)level {
    NSString *key = [NSString stringWithFormat:@"%ld",(long)level];
    return [[self.vocabSectionsToIndexes objectForKey:key] integerValue];
}

- (void)addWordToUserData:(NSString *)word {
    if (![[UserData instance] hasVocabFound:word]) {
        [[UserData instance] updateDictionaryWith:word];
        [[UserData instance] addUnseenWord:word];
        [[GameCenterHelper instance] reportScore:[UserData instance].pokedex.count];
    }
}

@end
