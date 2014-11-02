//
//  VocabularyTableView.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface VocabularyTableView : XibView  <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)setupWithData:(NSArray *)displaySectionHeaders
                 rows:(NSDictionary *)dictionary
displaySectionIndexes:(NSArray *)displaySectionIndexes
       sectionIndexes:(NSArray *)sectionIndexes
          unseenWords:(NSDictionary *)unseenWords;

- (void)scrollTo:(NSIndexPath *)indexPath;

@end
