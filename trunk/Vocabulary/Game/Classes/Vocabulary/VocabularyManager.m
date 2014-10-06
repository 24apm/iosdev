//
//  VocabularyManager.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyManager.h"
#import "VocabularyObject.h"
#import "NSArray+Util.h"

#define TEXT_FILE @"vocabulary.txt"
#define EMPTY_SPACE @"_"
#define MAX_STRING_LENGTH 8

@interface VocabularyManager()

@property (strong, nonatomic) NSMutableDictionary *vocabListByDictionary;
@property (strong, nonatomic) NSMutableArray *vocabListByArray;
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
    return [NSDictionary dictionaryWithDictionary:self.vocabListByDictionary];
}

- (int)maxCount {
    return self.vocabListByArray.count;
}

- (int)currentCount {
    //TODO look up userData for current Vocab Count
    return 5;
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
    
    self.vocabListByArray = [NSMutableArray array];
    
    self.vocabListByDictionary = [NSMutableDictionary dictionary];
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
        NSMutableArray *word = [NSMutableArray arrayWithArray:[vocabData.definition componentsSeparatedByString:@","]];
        vocabData.definition = word[0];
        
        // Array version
        [self.vocabListByArray addObject:vocabData];
        
        // Dictionary version
        NSString *key = [[vocabData.word substringToIndex:1] uppercaseString];
        NSMutableArray *vocabSection = [self.vocabListByDictionary objectForKey:key];
        if (vocabSection == nil) {
            vocabSection = [NSMutableArray array];
            [self.vocabListByDictionary setObject:vocabSection forKey:key];
        }
        [vocabSection addObject:vocabData];
    }
//    [self testMaxLength];
}

- (void)testMaxLength {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.vocabListByArray.count; i++) {
        VocabularyObject *vocabData = [self.vocabListByArray objectAtIndex:i];
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
    for (NSString *key in [self.vocabListByDictionary allKeys]) {
        NSLog(@"%@ %d", key, [[self.vocabListByDictionary objectForKey:key] count]);
    }
    NSLog(@"%@", self.vocabListByDictionary);
    
    NSLog(@"%@", self.vocabListByArray);
}


- (NSString *)randomLetter {
    NSString *randomLetter = [NSString stringWithFormat:@"%C", [self.letters characterAtIndex: arc4random_uniform([self.letters length]) % [self.letters length]]];
    return randomLetter;
}

- (LevelData *)generateLevel {
    LevelData *levelData = [[LevelData alloc] init];
    
    NSMutableArray *vocabularyList = [NSMutableArray array];
    
    // setup words
    while (vocabularyList.count < 9) {
        VocabularyObject *vocabData = [self.vocabListByArray randomObject];
        if (![vocabularyList containsObject:vocabData]) {
            [vocabularyList addObject:vocabData];
        }
    }
    
    // setup answer
    NSArray *finalAnswerSheet;
    NSMutableDictionary *answerSheets = [NSMutableDictionary dictionary];
    NSArray *words = vocabularyList;
    NSMutableArray *map = [NSMutableArray array];
    int total = NUM_COL * NUM_ROW;
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
        
        while(!didFit) {
            BOOL canFit = YES;
            
            int sRow = arc4random() % NUM_ROW;
            int sCol = arc4random() % NUM_COL;
            
            //            int directionalRow = arc4random() % 2 - 1; // -1, 0, or 1
            //            int directionalCol = arc4random() % 2 - 1; // -1, 0, or 1
            CGPoint randomDirectionalPoint = [self randomDirectionPoint];
            int directionalRow = randomDirectionalPoint.y;
            int directionalCol = randomDirectionalPoint.x;
            
            // test word placement
            for (int i = 0; i < word.length; i++) {
                int eRow = sRow + i * directionalRow;
                int eCol = sCol + i * directionalCol;
                int mapIndex = [self indexAtRow:eRow column:eCol];
                
                // test for:
                //  1) boundary check
                //  2) target space is empty
                //  3) and can match letter
                if (!(mapIndex > -1
                      && mapIndex < NUM_ROW * NUM_COL
                      && eRow > -1
                      && eCol > -1
                      && eRow < NUM_ROW
                      && eCol < NUM_COL
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
                    int mapIndex = [self indexAtRow:sRow + i * directionalRow column:sCol + i * directionalCol];
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
    
    levelData.vocabularyList = wordSortedByLength;
    levelData.letterMap = map;
    levelData.answerSheets = answerSheets;
    levelData.finalAnswerSheet = [finalAnswerSheet copy];
    return levelData;
}

- (NSUInteger)indexAtRow:(NSUInteger)r column:(NSUInteger)c {
    return r * NUM_COL + c;
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

- (void)printMap:(NSArray *)map {
     NSLog (@"%@", [self mapToString:map]);
}

- (NSString *)mapToString:(NSArray *)map {
    NSString *string = @"";
    for (int i = 0; i < NUM_ROW; i++) {
        for (int j = 0; j < NUM_COL; j++) {
            NSString *letter = [map objectAtIndex:[self indexAtRow:i column:j]];
            string = [NSString stringWithFormat:@"%@ %@",string,letter];
        }
        string = [string stringByAppendingString:@"\n"];
    }
    return string;
}

- (BOOL)checkSolution:(LevelData *)levelData word:(NSString *)word {
    for (VocabularyObject *vocabData in levelData.vocabularyList) {
        if ([word isEqualToString:vocabData.word]) {
            return YES; // found match
        }
    }
    return NO;
}

@end
