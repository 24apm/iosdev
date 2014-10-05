//
//  VocabularyTableDialogView.m
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "VocabularyTableDialogView.h"
#import "VocabularyManager.h"

@implementation VocabularyTableDialogView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progressLabel.text = [NSString stringWithFormat:@"%d/%d", [VocabularyManager instance].currentCount, [VocabularyManager instance].maxCount];
    }
    return self;
}
@end
