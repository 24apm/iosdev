//
//  VocabularyRowView.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "VocabularyObject.h"

@interface VocabularyRowView : XibView

@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@property (nonatomic) BOOL highlighted;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void)setupWithData:(VocabularyObject *)data;

@end
