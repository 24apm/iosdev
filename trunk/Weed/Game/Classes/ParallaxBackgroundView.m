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
#import "BuyerVisitorData.h"
#import "RealEstateManager.h"
#import "AppString.h"

@implementation ParallaxBackgroundView

//- (void)setup {
//    [self refresh];
//}

//- (void)refresh {
//    VisitorView *sampleVisitor = [self.visitorViews firstObject];
//    
//    VisitorView *randVisitor = [[VisitorView alloc] init];
//    randVisitor.frame = sampleVisitor.frame;
//    VisitorData *data = [[VisitorManager instance] nextVisitor];
//    [randVisitor setupWithData:data];
//    [self addSubview:randVisitor];
//    [randVisitor generateTarget];
//    [randVisitor animateIn];
//    float randX = arc4random() % (int)randVisitor.superview.width;
//    float randY = arc4random() % (int)randVisitor.height / 2;
//    randVisitor.center = CGPointMake(randX, sampleVisitor.center.y - randY);
//
//    float delay = [Utils randBetweenMin:1 max:5];
//    [self performSelector:@selector(refresh) withObject:nil afterDelay:delay];
//}

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
    
    float delay = [Utils randBetweenMin:1 max:5];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:delay];
}

- (IBAction)buyerVisitorPressed:(id)sender {
    if ([[RealEstateManager instance] canSellHouse]) {
        [[[VisitorManager instance] dialogFor:[BuyerVisitorData dummyData]] show];
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_BUYER_FAILED_HEADER bodyText:VISITOR_BUYER_FAILED_MESSAGE] show];
    }
}


@end
