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
    for (NSInteger i = 0; i < self.letters.length; i++) {
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
    NSInteger level = [self unlockUptoLevel];
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
        //vocabData.definition = vocabParts[1];
        
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
    NSInteger sectionIndex = 0;
    
    while(row = [nse nextObject]) {
        NSString *rawWord = row;
        
        NSInteger maxValue = MIN([rawWord integerValue], self.dictionaryByVocab.count - 1);
        rawWord = [NSString stringWithFormat:@"%ld", (long)maxValue];
        
        NSString *sectionString = [NSString stringWithFormat:@"%ld",(long)sectionIndex];
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
    NSString *randomLetter = [NSString stringWithFormat:@"%C", [self.letters characterAtIndex: arc4random_uniform((uint32_t)([self.letters length])) % [self.letters length]]];
    return randomLetter;
    
}

- (void)divideDictionary {
    NSMutableArray *allWords = [NSMutableArray arrayWithArray:[self.dictionaryByVocab allKeys]];
    [allWords shuffle];
    
    NSLog(@"COMPLETE");
    
}

- (NSInteger)unlockUptoLevel {
    return [self unlockedUptoLevel:[UserData instance].pokedex.count];
}

- (NSArray *)createNewWordArray {
    NSArray *allCurrentWords = [self mixVocabFromLevel:[self unlockUptoLevel] -1 toLevel:[self unlockUptoLevel]];
    NSMutableArray *newWordsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < allCurrentWords.count; i++) {
        if (![[UserData instance].pokedex containsObject: [allCurrentWords objectAtIndex:i]]) {
            VocabularyObject *vocabData = [self.dictionaryByVocab objectForKey:[allCurrentWords objectAtIndex:i]];
            [newWordsArray addObject:vocabData];
        }
    }
    return newWordsArray;
}

- (BOOL)canFitWord:(NSString *)word onLetterIndex:(NSInteger)index startAtRow:(NSInteger)sRow col:(NSInteger)sCol withDirectionRow:(NSInteger)directionalRow col:(NSInteger)directionalCol {
    
    BOOL possibleToFit = YES;
    NSInteger letterBefore = index;
    NSInteger letterAfter = word.length - (index + 1);
    // test word placement
    for (NSInteger i = 0; i <= letterAfter; i++) {
        NSInteger eRow = sRow + i * directionalRow;
        NSInteger eCol = sCol + i * directionalCol;
        NSInteger mapIndex = [self indexForLeveData:self.levelData row:eRow column:eCol];
        
        // test for:
        //  1) boundary check
        //  2) target space is empty
        //  3) and can match letter
        if (mapIndex > -1
            && mapIndex < self.levelData.numRow * self.levelData.numColumn
            && eRow > -1
            && eCol > -1
            && eRow < self.levelData.numRow
            && eCol < self.levelData.numColumn
            && ([[self.map objectAtIndex:mapIndex] isEqualToString:EMPTY_SPACE] ||
                [[self.map objectAtIndex:mapIndex] isEqualToString:[NSString stringWithFormat:@"%c",[word characterAtIndex:(index + i)]]])
            ) {
            // NSLog(@"bottom eRow %d eCol %d", eRow, eCol);
           // NSLog(@"%@",[NSString stringWithFormat:@"%c",[word characterAtIndex:0]]);
        } else {
            // NSLog(@"top eRow %d eCol %d", eRow, eCol);
            possibleToFit = NO;
            break;
            
        }
    }
    
    if (possibleToFit && (letterBefore > 0)) {
        for (NSInteger i = 0; i <= letterBefore; i++) {
            NSInteger eRow = sRow - i * directionalRow;
            NSInteger eCol = sCol - i * directionalCol;
            NSInteger mapIndex = [self indexForLeveData:self.levelData row:eRow column:eCol];
            
            // test for:
            //  1) boundary check
            //  2) target space is empty
            //  3) and can match letter
            if (mapIndex > -1
                && mapIndex < self.levelData.numRow * self.levelData.numColumn
                && eRow > -1
                && eCol > -1
                && eRow < self.levelData.numRow
                && eCol < self.levelData.numColumn
                && ([[self.map objectAtIndex:mapIndex] isEqualToString:EMPTY_SPACE] ||
                    [[self.map objectAtIndex:mapIndex] isEqualToString:[NSString stringWithFormat:@"%c",[word characterAtIndex:index - i]]])
                ) {
                //   NSLog(@"bottom eRow %d eCol %d", eRow, eCol);
            } else {         //       NSLog(@"bottom eRow %d eCol %d", eRow, eCol);
                possibleToFit = NO;
                break;
            }
        }
    }
    return possibleToFit;
}

- (LevelData *)generateLevel:(NSInteger)numOfWords row:(NSInteger)row col:(NSInteger)col {
    [self checkNewWordsFound];
    self.levelData = [[LevelData alloc] init];
    self.levelData.numOfWords = numOfWords;
    self.levelData.numColumn = col;
    self.levelData.numRow = row;
    //[self divideDictionary];
    // try to generateMap
    
    NSMutableDictionary *storedLetters = [NSMutableDictionary dictionary];
    
    
    
    BOOL generatedMap = NO;
    while(!generatedMap) {
        NSMutableArray *vocabularyList = [NSMutableArray array];
        
        // setup words
        NSArray *allWords = [self mixVocabFromLevel:0 toLevel:[self unlockUptoLevel]];
        if (self.gameWithNewWords) {
            NSArray *newWords = [self createNewWordArray];
            NSInteger numOfNewWords = [Utils randBetweenMinInt:1 max:4];
            for (NSInteger i = 0; i < numOfNewWords; i++) {
                [vocabularyList addObject:[newWords randomObject]];
            }
        }
        
        while (vocabularyList.count < self.levelData.numOfWords) {
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
        self.map = [NSMutableArray array];
        NSInteger total = self.levelData.numColumn * self.levelData.numRow;
        for (NSInteger i = 0; i < total; i++) {
            [self.map addObject:EMPTY_SPACE];
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
                //  BOOL canFit = NO;
                
                // break if we try enough
                if (attempts > WORD_FIT_ATTEMPTS) {
                    break;
                }
                attempts++;
                
                
                //find position
                
                NSInteger sRow = 0;
                NSInteger sCol = 0;
                NSInteger directionalRow = 0;
                NSInteger directionalCol = 0;
                
                //create direction order
                
                NSMutableArray *directionArray = [NSMutableArray array];
                for (NSInteger i = 0; i < 8; i ++) {
                    [directionArray addObject:[NSNumber numberWithInteger:i]];
                }
                [directionArray shuffle];
                
                BOOL foundAFit = NO;
                
                //loop through letter if has stored letters
                
                NSInteger letterIndex = 0;
                BOOL shouldOverlap = [Utils randBetweenTrueFalse];
                
                if (shouldOverlap && [storedLetters allKeys].count > 0) {
                    NSString *shuffleWord = [NSString shuffleString:word];
                    
                    for (NSInteger i = 0; i < word.length; i++) {
                        letterIndex = i;
                        NSString *currentLetter = [NSString stringWithFormat:@"%c", [shuffleWord characterAtIndex:i]];
                        
                        //check if storedLetter has points of current letter
                        
                        if ([storedLetters objectForKey:currentLetter] > 0) {
                            
                            //check for fit with ordered directions in linking words
                            
                            for (NSInteger i = 0; i < directionArray.count; i++) {
                                NSInteger direction = [[directionArray objectAtIndex:i] integerValue];
                                
                                CGPoint randomDirectionalPoint = [self directionPointLookUp:direction];
                                directionalRow = randomDirectionalPoint.y;
                                directionalCol = randomDirectionalPoint.x;
                                
                                NSArray *letterPointsArray = [storedLetters objectForKey:currentLetter];
                                for (NSInteger j = 0; j < letterPointsArray.count - 1; j+=2) {
                                    sRow = [[letterPointsArray objectAtIndex:j] integerValue];
                                    sCol = [[letterPointsArray objectAtIndex:j+1] integerValue];
                                    
                                    foundAFit = [self canFitWord:word onLetterIndex:letterIndex startAtRow:sRow col:sCol withDirectionRow:directionalRow col:directionalCol];
                                    if (foundAFit) {
                                        break;
                                    }
                                }
                                if (foundAFit) {
                                    break;
                                }
                            }
                        }
                        if (foundAFit) {
                            break;
                        }
                    }
                }
                
                // if don't have stored letters or can't fit in stored letters no linking
                if (!foundAFit || [storedLetters allKeys].count <= 0) {
                    sRow = arc4random() % self.levelData.numRow;
                    sCol = arc4random() % self.levelData.numColumn;
                    for (NSInteger i = 0; i < directionArray.count; i++) {
                        NSInteger direction = [[directionArray objectAtIndex:i] integerValue];
                        
                        CGPoint randomDirectionalPoint = [self directionPointLookUp:direction];
                        directionalRow = randomDirectionalPoint.y;
                        directionalCol = randomDirectionalPoint.x;
                        foundAFit = [self canFitWord:word onLetterIndex:0 startAtRow:sRow col:sCol withDirectionRow:directionalRow col:directionalCol];
                        if (foundAFit) {
                            letterIndex = 0;
                            break;
                        }
                    }
                }
                
                // place word
                if (foundAFit) {
                    NSMutableArray *answerIndexesToDrawWord = [NSMutableArray array];
                    NSInteger gap = word.length - (letterIndex + 1);
                    for (NSInteger i = 0; i <= gap; i++) {
                        NSInteger row = sRow + i * directionalRow;
                        NSInteger col = sCol + i * directionalCol;
                        NSInteger mapIndex = [self indexForLeveData:self.levelData row:row column:col];
                        NSString *letter = [NSString stringWithFormat:@"%c",[word characterAtIndex:letterIndex+ i]];
                        NSString *newString = letter;
                        
                        [self.map replaceObjectAtIndex:mapIndex withObject:newString];
                        
                        storedLetters = [self updateLetterDictionary:letter
                                                                  to:storedLetters
                                                             withRow:row
                                                             withCol:col];
                        
                        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(row, col)];
                        [answerIndexesToDrawWord addObject:point];
                        
                    }
                    
                    if (letterIndex > 0) {
                        for (NSInteger i = 0; i <= letterIndex; i++) {
                            NSInteger row = sRow - i * directionalRow;
                            NSInteger col = sCol - i * directionalCol;
                            NSInteger mapIndex = [self indexForLeveData:self.levelData row:row column:col];
                            NSString *letter = [NSString stringWithFormat:@"%c",[word characterAtIndex:letterIndex - i]];
                            NSString *newString = letter;
                            
                            [self.map replaceObjectAtIndex:mapIndex withObject:newString];
                            
                            storedLetters = [self updateLetterDictionary:letter
                                                                      to:storedLetters
                                                                 withRow:row
                                                                 withCol:col];
                            
                            NSValue *point = [NSValue valueWithCGPoint:CGPointMake(row, col)];
                            [answerIndexesToDrawWord addObject:point];
                            
                        }
                        
                    }
                    
                    didFit = YES;
                    [answerIndexesToDrawGroup setObject:answerIndexesToDrawWord forKey:word];
                    finalAnswerSheet = [self.map copy];
                    [answerSheets setObject:finalAnswerSheet forKey:word];
                }
            } // while(!didFit)
        }
        
        if (answerIndexesToDrawGroup.count >= wordSortedByLength.count) {
            // setup map
            for (NSInteger i = 0; i < total; i++) {
                NSString *letter = [self.map objectAtIndex:i];
                if ([letter isEqualToString:EMPTY_SPACE]) {
                    NSString *randomLetter = [self randomLetter];
                    [self.map replaceObjectAtIndex:i withObject:randomLetter];
                }
            }
            
            generatedMap = YES;
        }
        self.levelData.vocabularyList = wordSortedByLength;
        self.levelData.letterMap = self.map;
        self.levelData.answerSheets = answerSheets;
        self.levelData.finalAnswerSheet = [finalAnswerSheet copy];
        self.levelData.answerIndexesToDrawGroup = answerIndexesToDrawGroup;
    }
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
