//
//  ParallaxBackgroundView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxBackgroundView.h"
#import "VisitorManager.h"
#import "Utils.h"

@implementation ParallaxBackgroundView

- (void)setup {
    for (VisitorView *visitor in self.visitorViews) {
        visitor.hidden = YES;
    }
    [self refresh];
}

- (void)refresh {
    NSMutableArray *emptyVisitors = [NSMutableArray array];
    for (VisitorView *visitor in self.visitorViews) {
        if (visitor.data == nil) {
            [emptyVisitors addObject:visitor];
        }
    }
    if (emptyVisitors.count > 0) {
        VisitorView *randVisitor = [emptyVisitors randomObject];
        VisitorData *data = [[VisitorManager instance] nextVisitor];
        [randVisitor setupWithData:data];
        [randVisitor animateIn];
    }
    
    float delay = [Utils randBetweenMin:2 max:10];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:delay];
}

@end
