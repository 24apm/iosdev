//
//  ParallaxWorldView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxWorldView.h"
#import "ParallaxBackgroundView.h"
#import "ParallaxForegroundView.h"

@interface PassThroughView : UIScrollView

@end

@implementation PassThroughView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesBegan: touches withEvent: event];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesMoved: touches withEvent:event];
    }
    else{
        [super touchesMoved: touches withEvent: event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesEnded: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}

@end

@interface ParallaxWorldView()

@property (nonatomic, strong) NSMutableArray *parallaxViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ParallaxWorldView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.parallaxViews = [NSMutableArray array];
    

    ParallaxBackgroundView *backgroundView = [[ParallaxBackgroundView alloc] init];
    [self.parallaxViews addObject:backgroundView];
    
    ParallaxForegroundView *foregroundView = [[ParallaxForegroundView alloc] init];
    [self.parallaxViews addObject:foregroundView];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];

    self.scrollView.frame = self.frame;
    self.scrollView.autoresizingMask = foregroundView.autoresizingMask;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = foregroundView.frame.size;
    
    for (UIView *view in self.parallaxViews) {
        [self addSubview:view];
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentageOffsetX = scrollView.contentOffset.x / (scrollView.contentSize.width - self.width);
    for (UIView *view in self.parallaxViews) {
        view.x = -(view.width - self.width) * percentageOffsetX ;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self overlapHitTest:point withEvent:event];
  //  return [super hitTest:point withEvent:event];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self.nextResponder touchesBegan:touches withEvent:event];
//}

@end
