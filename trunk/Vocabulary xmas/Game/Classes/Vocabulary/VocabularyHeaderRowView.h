//
//  VocabularyRowView.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "VocabularyObject.h"
#import "LabelBase.h"

@interface VocabularyHeaderRowView : XibView
@property (strong, nonatomic) IBOutlet LabelBase *headerLabel;
@property (nonatomic) BOOL highlighted;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

- (void)setupWithData:(VocabularyObject *)data;

@end
