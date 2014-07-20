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
    [self refresh];
}

- (void)refresh {
    VisitorView *sampleVisitor = [self.visitorViews firstObject];
    
    VisitorView *randVisitor = [[VisitorView alloc] init];
    randVisitor.frame = sampleVisitor.frame;
    VisitorData *data = [[VisitorManager instance] nextVisitor];
    [randVisitor setupWithData:data];
    [self addSubview:randVisitor];
    [randVisitor generateTarget];
    [randVisitor animateIn];
    float randX = arc4random() % (int)randVisitor.superview.width;
    float randY = arc4random() % (int)randVisitor.height;
    randVisitor.center = CGPointMake(randX, sampleVisitor.center.y - randY);

    float delay = [Utils randBetweenMin:2 max:10];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:delay];
}


@end
