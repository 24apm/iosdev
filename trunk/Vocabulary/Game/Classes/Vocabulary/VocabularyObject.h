//
//  VocabularyObject.h
//  Vocabulary
//
//  Created by MacCoder on 10/4/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelObject.h"

@interface VocabularyObject : ModelObject

@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *definition;

@end
