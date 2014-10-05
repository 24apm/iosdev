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
    NSLog(@"randomLetter %@" , randomLetter);
    return randomLetter;
}

- (LevelData *)generateLevel {
    LevelData *levelData = [[LevelData alloc] init];
    
    NSMutableArray *vocabularyList = [NSMutableArray array];
    
    while (vocabularyList.count < 10) {
        VocabularyObject *vocabData = [self.vocabListByArray randomObject];
        if (![vocabularyList containsObject:vocabData]) {
            [vocabularyList addObject:vocabData];
        }
    }
    levelData.vocabularyList = vocabularyList;
    return levelData;
}

@end
