//
//  VisitorData.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface VisitorData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *occupation;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *imagePath;
@property (nonatomic) Gender gender;
@property (strong, nonatomic) NSString *messageBubble;

@end
