//
//  BoardView.m
//  Vocabulary
//
//  Created by MacCoder on 10/5/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BoardView.h"
#import "SlotView.h"
#import "VocabularyManager.h"
#import "CAEmitterHelperLayer.h"

#define NUM_COL 9
#define NUM_ROW 9

@interface BoardView()

@property (strong, nonatomic) NSMutableArray *slots;
@property (nonatomic) CGSize slotSize;
@property (strong, nonatomic) NSMutableArray *slotSelection;
@property (strong, nonatomic) UIImage *cachedLineImage;
@property (nonatomic) BOOL hasCorrectMatch;

@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.slots = [NSMutableArray array];
        float blockWidth = self.width / NUM_COL;
        self.slotSize = CGSizeMake(blockWidth, blockWidth);
        [self generateSlots];
        [self refreshSlots];
        self.slotSelection = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)reset {
    self.cachedLineImage = nil;
    [self.slotSelection removeAllObjects];
    [self refreshSlots];
    [self setNeedsDisplay];
}

- (void)refreshSlots {
    for (SlotView *slotView in self.slots) {
        slotView.labelView.text = [[VocabularyManager instance] randomLetter];
    }
}

- (void)generateSlots {
    for (int r = 0; r < NUM_ROW; r++) {
        for (int c = 0; c < NUM_COL; c++) {
            SlotView *slotView = [[SlotView alloc] init];
            slotView.frame = CGRectIntegral(CGRectMake(c * self.slotSize.width,
                                                       r * self.slotSize.height,
                                                       self.slotSize.width,
                                                       self.slotSize.height));
            slotView.userInteractionEnabled = NO;
            [self.slots addObject:slotView];
            [self addSubview:slotView];
        }
    }
}

- (SlotView *)slotAtPoint:(CGPoint)point {
    int row = (int)point.y / (int)self.slotSize.height;
    int col = (int)point.x / (int)self.slotSize.width;
    return [self slotAtRow:row column:col];
}

- (SlotView *)slotAtRow:(NSUInteger)r column:(NSUInteger)c {
    NSUInteger index = r * NUM_COL + c;
    if (index < self.slots.count) {
        return [self.slots objectAtIndex:index];
    } else {
        return nil;
    }
}

- (CGPoint)pointForSlot:(SlotView *)slotView {
    NSUInteger index = [self.slots indexOfObject:slotView];
    NSUInteger r = index / NUM_COL;
    NSUInteger c = index % NUM_COL;
    return CGPointMake(r, c);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    SlotView *slotView = [self slotAtPoint:location];
    if (slotView && !self.hasCorrectMatch) {
        self.hasCorrectMatch = NO;
        [self.slotSelection addObject:slotView];
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    SlotView *slotView = [self slotAtPoint:location];
    
    // return if nil
    if (!slotView) return;
    
    // return if still in the process of drawing last hasCorrect cache
    if (self.hasCorrectMatch) return;
    
    // return if before first element is added
    if (self.slotSelection.count <= 0) return;
    
    // return if the line is the same
    if (slotView == [self.slotSelection lastObject]) return;
    
    SlotView *firstSlotView = [self.slotSelection firstObject];
    
    CGPoint firstSlotPoint = [self pointForSlot:firstSlotView];
    CGPoint currentSlotPoint = [self pointForSlot:slotView];
    int distanceX = currentSlotPoint.x - firstSlotPoint.x;
    int distanceY = currentSlotPoint.y - firstSlotPoint.y;
    
    // get the unit versions
    if (distanceX == 0 ||                        // match row
        distanceY == 0 ||                        // match col
        abs(distanceX) == abs(distanceY)) {   // match horizontal
        
        // renew the line
        [self.slotSelection removeObjectsInRange:NSMakeRange(1, self.slotSelection.count-1)];
        
        int directionalUnitX = abs(distanceX) == 0 ? 0 : distanceX / (abs(distanceX));
        int directionalUnitY = abs(distanceY) == 0 ? 0 : distanceY / (abs(distanceY));

        // add line in the direction of the target slot
        int maxDistance = MAX(abs(distanceX), abs(distanceY));
        for (int i = 1; i <= maxDistance; i++) {
            slotView = [self slotAtRow:firstSlotPoint.x + i * directionalUnitX
                                column:firstSlotPoint.y + i * directionalUnitY];
            [self.slotSelection addObject:slotView];
        }
        [self setNeedsDisplay];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.hasCorrectMatch = arc4random() % 2 == 1; //TODO hardcoding to rand for now
    if (!self.hasCorrectMatch) {
        [self.slotSelection removeAllObjects];
    }
    [self setNeedsDisplay];
}

- (void)cacheImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];

    self.cachedLineImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end the context
    UIGraphicsEndImageContext();
}

- (void)drawPath:(UIBezierPath *)bezierPath {
    SlotView *slotView = [self.slotSelection objectAtIndex:0];
    
    [bezierPath moveToPoint:slotView.center];
    
    for (int i = 1; i < self.slotSelection.count; i++) {
        slotView = [self.slotSelection objectAtIndex:i];
        [bezierPath addLineToPoint:slotView.center];
    }
    
    slotView = [self.slotSelection lastObject];
    
    [bezierPath stroke];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    [self.cachedLineImage drawInRect:rect];
    
    if (self.slotSelection.count > 0) {
        
        UIColor *outerStrokeColor;
        UIColor *innerStrokeColor;
        
        if (self.hasCorrectMatch) {
            outerStrokeColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5f];
            innerStrokeColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5f];
        } else {
            outerStrokeColor = [UIColor colorWithRed:0 green:0 blue:1.f alpha:0.5f];
            innerStrokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5f];
        }
        
        //Outer
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        CGContextSetStrokeColorWithColor(context, [outerStrokeColor CGColor]);
        bezierPath.lineWidth = self.slotSize.width * 0.6f;
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        bezierPath.lineCapStyle = kCGLineCapRound;
        
        [self drawPath:bezierPath];
        
        //Inner
        UIBezierPath *bezierPathInner = [UIBezierPath bezierPath];
        CGContextSetStrokeColorWithColor(context, [innerStrokeColor CGColor]);
        bezierPathInner.lineWidth =  self.slotSize.width * 0.5f;
        bezierPathInner.lineJoinStyle = kCGLineJoinRound;
        bezierPathInner.lineCapStyle = kCGLineCapRound;

        [self drawPath:bezierPathInner];
        
        if (self.hasCorrectMatch) {
            [self cacheImage];
            [self.slotSelection removeAllObjects];
            self.hasCorrectMatch = NO;
        }
    }
}

@end
