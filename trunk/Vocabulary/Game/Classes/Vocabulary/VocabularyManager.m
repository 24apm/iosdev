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
@property (nonatomic) int gamesNoNewWord;
@property (nonatomic) BOOL gameWithNewWords;


@property (strong, nonatomic) NSString *letters;

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
        self.letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
           self.foundNewWord = YES;
    }
    return self;
}

- (NSDictionary *)vocabList {
    return [NSDictionary dictionaryWithDictionary:self.dictionaryBySection];
}

- (NSDictionary *)userVocabList {
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionary];
    NSArray *userSavedKeys = [UserData instance].pokedex;
    for (int i = 0; i < self.letters.length; i++) {
        NSString *key = [NSString stringWithFormat:@"%c",[self.letters characterAtIndex:i]];
        [userDictionary setObject:[NSMutableArray array] forKey:key];
    }
    
    for (NSString *word in userSavedKeys) {
        [self populateSectionDictionary:userDictionary word:word];
    }
    return [NSDictionary dictionaryWithDictionary:userDictionary];
}

- (NSDictionary *)userMixedVocabList {
    // filter up to unlocked level
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    int level = [self unlockUptoLevel];
    for (NSString *key in [self.mixedVocabDictionaryBySection allKeys]) {
        if ([key intValue] < level) {
            [dictionary setObject:[self.mixedVocabDictionaryBySection objectForKey:key] forKey:key];
        } else {
            [dictionary setObject:[NSArray array] forKey:key];
        }
    }
    return dictionary;
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

- (void)loadFile {
    NSString *row;
    NSArray *lines;
    NSError *error;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:TEXT_FILE ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    lines = [content componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    self.dictionaryByVocab = [NSMutableDictionary dictionary];
    
    self.dictionaryBySection = [NSMutableDictionary dictionary];
    while(row = [nse nextObject]) {
        
        NSMutableArray *vocabParts = [NSMutableArray arrayWithArray:[row componentsSeparatedByString:@"\t"]];
        NSString *rawWord = vocabParts[0];
        if (rawWord.length > MAX_STRING_LENGTH) {
            continue;
        }
        VocabularyObject *vocabData = [[VocabularyObject alloc] init];
        vocabData.word = vocabParts[0];
        vocabData.definition = vocabParts[1];
        
        // "palliate, palliative" -> "palliate"
        NSMutableArray *word = [NSMutableArray arrayWithArray:[vocabData.word componentsSeparatedByString:@","]];
        vocabData.word = word[0];
        
        // Dictionary flat version
        [self.dictionaryByVocab setObject:vocabData forKey:vocabData.word];
        
        // Dictionary section version
        [self populateSectionDictionary:self.dictionaryBySection word:vocabData.word];
    }
    //    [self testMaxLength];
    
    [self loadFileForMix];
    [self loadFileForIndexes];
    [self setupMixedDictionary];
}

- (void)setupMixedDictionary {
    NSMutableDictionary *mixedDictionaryBySection = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.vocabSectionsToIndexes.count - 1; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        
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
        
        [self.mixVocabArray addObject:rawWord];
    }
}

- (void)loadFileForIndexes {
    NSString *row;
    NSArray *lines;
    NSError *error;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"mixvocabularyIndexes.txt" ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    lines = [content componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    self.vocabSectionsToIndexes = [NSMutableDictionary dictionary];
    self.vocabIndexesToSections = [NSMutableDictionary dictionary];
    int sectionIndex = 0;
    
    while(row = [nse nextObject]) {
        NSString *rawWord = row;
        NSString *sectionString = [NSString stringWithFormat:@"%d",sectionIndex];
        [self.vocabSectionsToIndexes setValue:rawWord forKey:sectionString];
        [self.vocabIndexesToSections setValue:sectionString forKey:rawWord];
        sectionIndex++;
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

- (void)populateSectionDictionary:(NSMutableDictionary *)dictionary word:(NSString *)word {
    NSString *key = [[word substringToIndex:1] uppercaseString];
    NSMutableArray *vocabSection = [dictionary objectForKey:key];
    [vocabSection addObject:word];
}

- (void)testMaxLength {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (VocabularyObject *vocabData in self.dictionaryByVocab) {
        NSString *lengthLabel = [NSString stringWithFormat:@"%lu", (unsigned long)vocabData.word.length];
        if (![dictionary objectForKey:lengthLabel]) {
            [dictionary setObject:@(0) forKey:lengthLabel];
        }
        NSInteger value = [[dictionary objectForKey:lengthLabel] integerValue];
        [dictionary setObject:@(value+1) forKey:lengthLabel];
    }
    NSLog(@"testMaxLength %@", dictionary);
}

- (void)printDebug {
    for (NSString *key in [self.dictionaryBySection allKeys]) {
        NSLog(@"%@ %lu", key, (unsigned long)[[self.dictionaryBySection objectForKey:key] count]);
    }
    NSLog(@"%@", self.dictionaryBySection);
    
    NSLog(@"%@", self.dictionaryByVocab);
}


- (NSString *)randomLetter {
    NSString *randomLetter = [NSString stringWithFormat:@"%C", [self.letters characterAtIndex: arc4random_uniform([self.letters length]) % [self.letters length]]];
    return randomLetter;
    
}

- (void)divideDictionary {
    NSMutableArray *allWords = [NSMutableArray arrayWithArray:[self.dictionaryByVocab allKeys]];
    [allWords shuffle];
    
    NSLog(@"COMPLETE");
    
}

- (int)unlockUptoLevel {
    return [self unlockedUptoLevel:[UserData instance].pokedex.count];
}

- (NSArray *)createNewWordArray {
    NSArray *allCurrentWords = [self mixVocabFromLevel:[self unlockUptoLevel] -1 toLevel:[self unlockUptoLevel]];
    NSMutableArray *newWordsArray = [NSMutableArray array];
    for (int i = 0; i < allCurrentWords.count; i++) {
        if (![[UserData instance].pokedex containsObject: [allCurrentWords objectAtIndex:i]]) {
            VocabularyObject *vocabData = [self.dictionaryByVocab objectForKey:[allCurrentWords objectAtIndex:i]];
            [newWordsArray addObject:vocabData];
        }
    }
    return newWordsArray;
}

- (LevelData *)generateLevel:(NSInteger)numOfWords row:(NSInteger)row col:(NSInteger)col {
    [self checkNewWordsFound];
    LevelData *levelData = [[LevelData alloc] init];
    levelData.numOfWords = numOfWords;
    levelData.numColumn = col;
    levelData.numRow = row;
    //[self divideDictionary];
    // try to generateMap
    
    
    BOOL generatedMap = NO;
    while(!generatedMap) {
        NSMutableArray *vocabularyList = [NSMutableArray array];
        
        // setup words
        NSArray *allWords = [self mixVocabFromLevel:0 toLevel:[self unlockUptoLevel]];
        if (self.gameWithNewWords) {
            NSArray *newWords = [self createNewWordArray];
            [vocabularyList addObject:[newWords randomObject]];
        }
        
        while (vocabularyList.count < levelData.numOfWords) {
            NSString *randomWord = [allWords randomObject];
            VocabularyObject *vocabData = [self.dictionaryByVocab objectForKey:randomWord];
            if (![vocabularyList containsObject:vocabData]) {
                [vocabularyList addObject:vocabData];
            }
        }
        
        // setup answer
        NSArray *finalAnswerSheet;
        NSMutableDictionary *answerIndexesToDrawGroup = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *answerSheets = [NSMutableDictionary dictionary];
        NSArray *words = vocabularyList;
        NSMutableArray *map = [NSMutableArray array];
        NSInteger total = levelData.numColumn * levelData.numRow;
        for (int i = 0; i < total; i++) {
            [map addObject:EMPTY_SPACE];
        }
        
        NSMutableArray *wordSortedByLength = [NSMutableArray arrayWithArray:words];
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word.length"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        [wordSortedByLength sortUsingDescriptors:sortDescriptors];
        
        for (VocabularyObject *vocabData in wordSortedByLength) {
            NSString *word = vocabData.word;
            BOOL didFit = NO;
            NSInteger attempts = 0;
            
            while(!didFit) {
                BOOL canFit = YES;
                
                // break if we try enough
                if (attempts > WORD_FIT_ATTEMPTS) {
                    break;
                }
                attempts++;
                
                int sRow = arc4random() % levelData.numRow;
                int sCol = arc4random() % levelData.numColumn;
                
                //            int directionalRow = arc4random() % 2 - 1; // -1, 0, or 1
                //            int directionalCol = arc4random() % 2 - 1; // -1, 0, or 1
                CGPoint randomDirectionalPoint = [self randomDirectionPoint];
                int directionalRow = randomDirectionalPoint.y;
                int directionalCol = randomDirectionalPoint.x;
                
                // test word placement
                for (int i = 0; i < word.length; i++) {
                    int eRow = sRow + i * directionalRow;
                    int eCol = sCol + i * directionalCol;
                    NSInteger mapIndex = [self indexForLeveData:levelData row:eRow column:eCol];
                    
                    // test for:
                    //  1) boundary check
                    //  2) target space is empty
                    //  3) and can match letter
                    if (!(mapIndex > -1
                          && mapIndex < levelData.numRow * levelData.numColumn
                          && eRow > -1
                          && eCol > -1
                          && eRow < levelData.numRow
                          && eCol < levelData.numColumn
                          && ([[map objectAtIndex:mapIndex] isEqualToString:EMPTY_SPACE] ||
                              [[map objectAtIndex:mapIndex] isEqualToString:[NSString stringWithFormat:@"%c",[word characterAtIndex:i]]]))
                        
                        ) {
                        
                        canFit = NO;
                        break;
                    }
                }
                
                // place word
                if (canFit) {
                    NSMutableArray *answerIndexesToDrawWord = [NSMutableArray array];
                    for (int i = 0; i < word.length; i++) {
                        int row = sRow + i * directionalRow;
                        int col = sCol + i * directionalCol;
                        NSInteger mapIndex = [self indexForLeveData:levelData row:row column:col];
                        NSString *newString = [NSString stringWithFormat:@"%c",[word characterAtIndex:i]];
                        [map replaceObjectAtIndex:mapIndex withObject:newString];
                        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(row, col)];
                        [answerIndexesToDrawWord addObject:point];
                    }
                    didFit = YES;
                    [answerIndexesToDrawGroup setObject:answerIndexesToDrawWord forKey:word];
                    finalAnswerSheet = [map copy];
                    [answerSheets setObject:finalAnswerSheet forKey:word];
                }
            } // while(!didFit)
        }
        
        if (answerIndexesToDrawGroup.count >= wordSortedByLength.count) {
            // setup map
            for (int i = 0; i < total; i++) {
                NSString *letter = [map objectAtIndex:i];
                if ([letter isEqualToString:EMPTY_SPACE]) {
                    NSString *randomLetter = [self randomLetter];
                    [map replaceObjectAtIndex:i withObject:randomLetter];
                }
            }
            
            generatedMap = YES;
            levelData.vocabularyList = wordSortedByLength;
            levelData.letterMap = map;
            levelData.answerSheets = answerSheets;
            levelData.finalAnswerSheet = [finalAnswerSheet copy];
            levelData.answerIndexesToDrawGroup = answerIndexesToDrawGroup;
        }
    }
    return levelData;
}

- (NSUInteger)indexForLeveData:(LevelData *)levelData row:(NSUInteger)r column:(NSUInteger)c {
    return r * levelData.numColumn + c;
}

- (CGPoint)randomDirectionPoint {
    CGPoint directionalPoint;
    int direction = 7;
    int orderRatio = arc4random() % 3;
    if (orderRatio <= 1) {
        direction = [Utils randBetweenMinInt:0 max:3];
    } else {
        direction = [Utils randBetweenMinInt:4 max:7];
    }
    
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

- (BOOL)hasCompletedLevel:(LevelData *)levelData {
    // compare found words against all words
    for (VocabularyObject *vocabData in levelData.vocabularyList) {
        if (![levelData.wordsFoundList containsObject:vocabData.word]) {
            return NO;
        }
    }
    return YES;
}

- (void)printMap:(LevelData *)levelData {
    NSLog (@"%@", [self mapToString:levelData map:levelData.letterMap]);
}

- (void)printAnswer:(LevelData *)levelData {
    NSLog (@"%@", [self mapToString:levelData map:levelData.letterMap]);
}

- (NSString *)mapToString:(LevelData *)levelData map:(NSArray *)map {
    NSString *string = @"";
    for (int i = 0; i < levelData.numRow; i++) {
        for (int j = 0; j < levelData.numColumn; j++) {
            NSString *letter = [map objectAtIndex:[self indexForLeveData:levelData row:i column:j]];
            string = [NSString stringWithFormat:@"%@ %@",string,letter];
        }
        string = [string stringByAppendingString:@"\n"];
    }
    return string;
}

- (NSMutableArray *)mixVocabFromLevel:(int)start toLevel:(int)end  {
    int levelStart = [self mixVocabIndexWith:start];
    int levelEnd = [self mixVocabIndexWith:end];
    NSMutableArray *currentLevelVocab = [NSMutableArray array];
    for (int i = levelStart; i < levelEnd; i++) {
        [currentLevelVocab addObject:[self.mixVocabArray objectAtIndex:i]];
    }
    return currentLevelVocab;
}

- (int)unlockedUptoLevel:(int)wordsFound {
    NSArray *sortedMixedVocabsIndexes = [[self.vocabIndexesToSections allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue]==[obj2 intValue])
            return NSOrderedSame;
        else if ([obj1 intValue]<[obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    
    int i = 0;
    for (; i < sortedMixedVocabsIndexes.count; i++) {
        int index = [[sortedMixedVocabsIndexes objectAtIndex:i] integerValue];
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
    
    if (self.gamesNoNewWord > 2) {
        self.gameWithNewWords = YES;
    } else {
        self.gameWithNewWords = NO;
    }
}

- (int)mixVocabIndexWith:(int)level {
    NSString *key = [NSString stringWithFormat:@"%d",level];
    return [[self.vocabSectionsToIndexes objectForKey:key] integerValue];
    
    //    int index = 0;
    //    switch (level) {
    //        case 0:
    //            index = 0;
    //            break;
    //        case 1:
    //            index = 10;
    //            break;
    //        case 2:
    //            index = 50;
    //            break;
    //        case 3:
    //            index = 70;
    //            break;
    //        case 4:
    //            index = 90;
    //            break;
    //        case 5:
    //            index = 110;
    //            break;
    //        case 6:
    //            index = 130;
    //            break;
    //        case 7:
    //            index = 150;
    //            break;
    //        case 8:
    //            index = 180;
    //            break;
    //        case 9:
    //            index = 210;
    //            break;
    //        case 10:
    //            index = 240;
    //            break;
    //        case 11:
    //            index = 270;
    //            break;
    //        case 12:
    //            index = 300;
    //            break;
    //        case 13:
    //            index = 340;
    //            break;
    //        case 14:
    //            index = 380;
    //            break;
    //        case 15:
    //            index = 420;
    //            break;
    //        case 16:
    //            index = 460;
    //            break;
    //        case 17:
    //            index = 500;
    //            break;
    //        case 18:
    //            index = 550;
    //            break;
    //        case 19:
    //            index = 600;
    //            break;
    //        case 20:
    //            index = 650;
    //            break;
    //        case 21:
    //            index = 700;
    //            break;
    //        case 22:
    //            index = 750;
    //            break;
    //        case 23:
    //            index = 800;
    //            break;
    //
    //        default:
    //            break;
    //    }
    //    return index;
}

@end
