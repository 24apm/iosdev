//
//  VocabularyTableView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyTableView.h"
#import "VocabularyManager.h"
#import "XibTableViewCell.h"
#import "VocabularyRowView.h"
#import "VocabularyObject.h"
#import "UserData.h"

@interface VocabularyTableView()

@property (strong, nonatomic) NSDictionary *vocabularyDictionary;
@property (nonatomic) CGRect cellFrame;
@property (strong, nonatomic) NSArray *sortedDisplaySectionHeaders;
@property (strong, nonatomic) NSArray *sortedDisplaySectionIndexes;
@property (strong, nonatomic) NSArray *sortedSectionIndexes;
@property (strong, nonatomic) NSDictionary *unseenWords;

@property (nonatomic) BOOL isLevel;

@end

@implementation VocabularyTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setupWithData:(NSArray *)displaySectionHeaders
                 rows:(NSDictionary *)dictionary
displaySectionIndexes:(NSArray *)displaySectionIndexes
       sectionIndexes:(NSArray *)sectionIndexes
          unseenWords:(NSDictionary *)unseenWords {
    
    self.vocabularyDictionary = dictionary;
    self.sortedDisplaySectionHeaders = displaySectionHeaders;
    self.sortedDisplaySectionIndexes = displaySectionIndexes;
    self.sortedSectionIndexes = sectionIndexes;
    self.unseenWords = unseenWords;
    [self refresh];
}

- (void)scrollTo:(NSIndexPath *)indexPath {
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)setup {
    VocabularyRowView *t = [[VocabularyRowView alloc] init];
    self.cellFrame = t.frame;
    
    if ([self.tableView respondsToSelector:@selector(sectionIndexBackgroundColor)]) {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    if ([self.tableView respondsToSelector:@selector(sectionIndexColor)]) {
        self.tableView.sectionIndexColor = [UIColor colorWithRed:75.f/255.f green:211.f/255.f blue:193.f/255.f alpha:1.0f];
    }
}

- (void)refresh {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.vocabularyDictionary allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sortedDisplaySectionHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.vocabularyDictionary valueForKey:[self.sortedSectionIndexes objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortedDisplaySectionIndexes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VocabularyRowView"];
    if (!cell) {
        cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VocabularyRowView" className:@"VocabularyRowView"];
    }
    VocabularyRowView *rowView = (VocabularyRowView *)cell.view;
    NSString *key = [self.sortedSectionIndexes objectAtIndex:indexPath.section];
    NSString *vocab = [[self.vocabularyDictionary objectForKey:key] objectAtIndex:indexPath.row];
    
    VocabularyObject *vocabData = [[VocabularyManager instance] vocabObjectForWord:vocab];
    [rowView setupWithData:vocabData];
    rowView.highlighted = [self.unseenWords objectForKey:vocabData.word] != nil;
    [[UserData instance] removeUnseenWord:vocabData.word];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellFrame.size.height;
}


@end
