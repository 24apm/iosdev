//
//  VisitorManager.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisitorData.h"
#import "XibDialogView.h"

@interface VisitorManager : NSObject

+ (VisitorManager *)instance;

- (VisitorData *)nextVisitor;
- (XibDialogView *)dialogFor:(VisitorData *)visitorData;

@end
