//
//  ModelObject.h
//  BaseLibrary
//
//  Created by MacCoder on 10/12/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelObject : NSObject

- (void)deserialize:(NSDictionary *)dict;
- (NSDictionary *)serialize;

@end
