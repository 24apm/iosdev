//
//  VocabularyTableDialogView.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimatingDialogView.h"

#define VocabularyTableDialogViewDimissed @"VocabularyTableDialogViewDimissed"

@class VocabularyTableView;

@interface VocabularyTableDialogView : AnimatingDialogView

@property (strong, nonatomic) IBOutlet VocabularyTableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;

@end
