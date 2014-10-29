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
@property (strong, nonatomic) NSArray *sortedSectionHeaders;

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

- (void)setupWithData:(NSArray *)sections rows:(NSDictionary *)dictionary {
    self.vocabularyDictionary = dictionary;
    self.sortedSectionHeaders = sections;
    [self refresh];
}

- (void)setup {
    VocabularyRowView *t = [[VocabularyRowView alloc] init];
    self.cellFrame = t.frame;

//    self.vocabularyDictionary = [[VocabularyManager instance] userVocabList];
//    
//    self.sortedSectionHeaders = [[self.vocabularyDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self refresh];
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
    return [self.sortedSectionHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.vocabularyDictionary valueForKey:[self.sortedSectionHeaders objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortedSectionHeaders;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VocabularyRowView"];
    if (!cell) {
        cell = [[XibTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VocabularyRowView" className:@"VocabularyRowView"];
    }
    VocabularyRowView *rowView = (VocabularyRowView *)cell.view;
    NSString *key = [self.sortedSectionHeaders objectAtIndex:indexPath.section];
    NSString *vocab = [[self.vocabularyDictionary objectForKey:key] objectAtIndex:indexPath.row];
    
    [rowView setupWithData:[[VocabularyManager instance] vocabObjectForWord:vocab]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellFrame.size.height;
}


@end
