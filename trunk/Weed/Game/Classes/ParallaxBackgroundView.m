//
//  ParallaxBackgroundView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxBackgroundView.h"
#import "VisitorManager.h"

@implementation ParallaxBackgroundView

- (void)setup {
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:VisitorViewRefreshNotification object:nil];
}

- (void)refresh {
    for (VisitorView *visitor in self.visitorViews) {
        if (visitor.data == nil) {
            VisitorData *data = [[VisitorManager instance] nextVisitor];
            [visitor setupWithData:data];
            visitor.hidden = NO;
        }
    }
}

@end
