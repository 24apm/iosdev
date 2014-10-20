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

#define TEXT_FILE @"vocabulary.txt"
#define EMPTY_SPACE @"_"
#define MAX_STRING_LENGTH 8
#define NUM_OF_WORDS 9
#define WORD_FIT_ATTEMPTS 50

@interface VocabularyManager()

@property (strong, nonatomic) NSMutableDictionary *dictionaryBySection;
@property (strong, nonatomic) NSMutableDictionary *dictionaryByVocab;
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

- (instancetype)init {
    self = [super init];
    if (self) {
//         self.letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        self.letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    }
    return self;
}

- (NSDictionary *)vocabList {
    return [NSDictionary dictionaryWithDictionary:self.dictionaryBySection];
}

- (NSDictionary *)userVocabList {
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionary];
    NSArray *userSavedKeys = [UserData instance].pokedex;
    
    for (NSString *word in userSavedKeys) {
        VocabularyObject *vocabData = [self.dictionaryByVocab objectForKey:word];
        
        [self populateSectionDictionary:userDictionary vocabData:vocabData];
        
    }
    return [NSDictionary dictionaryWithDictionary:userDictionary];
}

- (int)maxCount {
    return self.dictionaryByVocab.count;
}

- (int)currentCount {
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
        [self populateSectionDictionary:self.dictionaryBySection vocabData:vocabData];
    }
//    [self testMaxLength];
}

- (VocabularyObject *)vocabObjectForWord:(NSString *)word {
    return [self.dictionaryByVocab objectForKey:word];
}

- (void)populateSectionDictionary:(NSMutableDictionary *)dictionary vocabData:(VocabularyObject *)vocabData {
    NSString *key = [[vocabData.word substringToIndex:1] uppercaseString];
    NSMutableArray *vocabSection = [dictionary objectForKey:key];
    if (vocabSection == nil) {
        vocabSection = [NSMutableArray array];
        [dictionary setObject:vocabSection forKey:key];
    }
    [vocabSection addObject:vocabData];
}

- (void)testMaxLength {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (VocabularyObject *vocabData in self.dictionaryByVocab) {
        NSString *lengthLabel = [NSString stringWithFormat:@"%d", vocabData.word.length];
        if (![dictionary objectForKey:lengthLabel]) {
            [dictionary setObject:@(0) forKey:lengthLabel];
        }
        int value = [[dictionary objectForKey:lengthLabel] integerValue];
        [dictionary setObject:@(value+1) forKey:lengthLabel];
    }
    NSLog(@"testMaxLength %@", dictionary);
}

- (void)printDebug {
    for (NSString *key in [self.dictionaryBySection allKeys]) {
        NSLog(@"%@ %d", key, [[self.dictionaryBySection objectForKey:key] count]);
    }
    NSLog(@"%@", self.dictionaryBySection);
    
    NSLog(@"%@", self.dictionaryByVocab);
}


- (NSString *)randomLetter {
    NSString *randomLetter = [NSString stringWithFormat:@"%C", [self.letters characterAtIndex: arc4random_uniform([self.letters length]) % [self.letters length]]];
    return randomLetter;
}

- (LevelData *)generateLevel:(NSInteger)numOfWords row:(NSInteger)row col:(NSInteger)col {
    LevelData *levelData = [[LevelData alloc] init];
    levelData.numOfWords = numOfWords;
    levelData.numColumn = col;
    levelData.numRow = row;
    
    // try to generateMap
    BOOL generatedMap = NO;
    while(!generatedMap) {
        NSMutableArray *vocabularyList = [NSMutableArray array];
        
        // setup words
        while (vocabularyList.count < levelData.numOfWords) {
            NSArray *allWords = [self.dictionaryByVocab allKeys];
            NSString *randomWord = [allWords randomObject];
            VocabularyObject *vocabData = [self.dictionaryByVocab objectForKey:randomWord];
            if (![vocabularyList containsObject:vocabData]) {
                [vocabularyList addObject:vocabData];
            }
        }
        
        // setup answer
        NSArray *finalAnswerSheet;
        NSMutableDictionary *answerSheets = [NSMutableDictionary dictionary];
        NSArray *words = vocabularyList;
        NSMutableArray *map = [NSMutableArray array];
        int total = levelData.numColumn * levelData.numRow;
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
                    NSLog(@"WORD_FIT_ATTEMPTS");
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
                    int mapIndex = [self indexForLeveData:levelData row:eRow column:eCol];
                    
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
                    for (int i = 0; i < word.length; i++) {
                        int mapIndex = [self indexForLeveData:levelData row:sRow + i * directionalRow column:sCol + i * directionalCol];
                        NSString *newString = [NSString stringWithFormat:@"%c",[word characterAtIndex:i]];
                        [map replaceObjectAtIndex:mapIndex withObject:newString];
                    }
                    didFit = YES;
                    finalAnswerSheet = [map copy];
                    [answerSheets setObject:finalAnswerSheet forKey:word];
                }
            }
        }
        
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
    }
    return levelData;
}

- (NSUInteger)indexForLeveData:(LevelData *)levelData row:(NSUInteger)r column:(NSUInteger)c {
    return r * levelData.numColumn + c;
}

- (CGPoint)randomDirectionPoint {
    CGPoint directionalPoint;
    int direction = arc4random() % 8;
    switch (direction) {
        // top left
        case 0: {
            directionalPoint.y = -1;
            directionalPoint.x = -1;
        }
        break;
        // top
        case 1: {
            directionalPoint.y = -1;
            directionalPoint.x = 0;
        }
        break;
        // top right
        case 2: {
            directionalPoint.y = -1;
            directionalPoint.x = 1;
        }
        break;
        // right
        case 3: {
            directionalPoint.y = 0;
            directionalPoint.x = 1;
        }
        break;
        // bottom right
        case 4: {
            directionalPoint.y = 1;
            directionalPoint.x = 1;
        }
        break;
        // bottom
        case 5: {
            directionalPoint.y = 1;
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

@end
