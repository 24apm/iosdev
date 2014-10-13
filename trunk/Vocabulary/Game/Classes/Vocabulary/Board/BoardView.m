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
#import "NSString+StringUtils.h"

@interface BoardView()

@property (strong, nonatomic) NSMutableArray *slots;
@property (nonatomic) CGSize slotSize;
@property (strong, nonatomic) NSMutableArray *slotSelection;
@property (strong, nonatomic) UIImage *cachedLineImage;
@property (nonatomic) BOOL hasCorrectMatch;
@property (strong, nonatomic) LevelData *levelData;
@property (nonatomic) CGPoint firstLocation;
@property (nonatomic) CGPoint previousPoint;
@property (nonatomic) NSInteger previousMax;
@property (nonatomic) CGPoint previousFirstSlotPoint;
@property (strong, nonatomic) SlotView *previousSelectedSlotView;

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
        self.firstLocation = CGPointMake(0.f, 0.f);
        [self resetPreviousLine];
    }
    return self;
}

- (void)resetPreviousLine {
    self.previousFirstSlotPoint = CGPointZero;
    self.previousPoint = CGPointZero;
    self.previousMax = 0;
}


- (void)setupWithLevel:(LevelData *)levelData {
    self.levelData = levelData;
    self.cachedLineImage = nil;
    [self.slotSelection removeAllObjects];
    [self refreshSlots];
    [self setNeedsDisplay];
}

- (void)refreshSlots {
    for (int i = 0; i < self.slots.count; i++) {
        SlotView *slotView = [self.slots objectAtIndex:i];
        NSString *letter = [self.levelData.letterMap objectAtIndex:i];
        slotView.labelView.text = letter;
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

- (SlotView *)slotAtScreenPoint:(CGPoint)point {
    NSInteger row = (int)point.y / (int)self.slotSize.height;
    NSInteger col = (int)point.x / (int)self.slotSize.width;
    return [self slotAtRow:row column:col];
}

- (SlotView *)slotAtRow:(NSInteger)r column:(NSInteger)c {
    if (r >= NUM_ROW || c >= NUM_COL || r < 0 || c < 0) {
        return nil;
    }
    NSUInteger index = r * NUM_COL + c;
    if (index < self.slots.count) {
        return [self.slots objectAtIndex:index];
    } else {
        return nil;
    }
}

- (CGPoint)gridPointForSlot:(SlotView *)slotView {
    NSUInteger index = [self.slots indexOfObject:slotView];
    NSUInteger r = index / NUM_COL;
    NSUInteger c = index % NUM_COL;
    return CGPointMake(r, c);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    SlotView *slotView = [self slotAtScreenPoint:location];
    if (slotView && !self.hasCorrectMatch) {
        self.hasCorrectMatch = NO;
        [slotView animateLabelSelection];
        [self.slotSelection addObject:slotView];
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    if (self.firstLocation.x == 0 && self.firstLocation.y == 0) {
        self.firstLocation = location;
    }
    
    SlotView *slotView = [self slotAtScreenPoint:location];

    // return if nil
    if (!slotView) return;
    
    // return if same tile is highlighted again
    if (self.previousSelectedSlotView == slotView) return;
    self.previousSelectedSlotView = slotView;
    
    // return if still in the process of drawing last hasCorrect cache
    if (self.hasCorrectMatch) return;
    
    // return if before first element is added
    if (self.slotSelection.count <= 0) return;

    // return if the line is the same
    if (slotView == [self.slotSelection lastObject]) return;
    
    SlotView *firstSlotView = [self.slotSelection firstObject];
    
    [slotView animateLabelSelection];
    
    
    float gapY = location.y - self.firstLocation.y;
    float gapX = location.x - self.firstLocation.x;
    
    CGPoint firstSlotPoint = [self gridPointForSlot:firstSlotView];
    CGPoint touchGridPoint = [self gridPointForSlot:slotView];
    
    int distanceX = touchGridPoint.x - firstSlotPoint.x;
    int distanceY = touchGridPoint.y - firstSlotPoint.y;
    
    NSInteger maxDistance = MAX(fabs(distanceX), fabs(distanceY));
    
    [self slotAtRow:maxDistance column:maxDistance];
    
    NSLog(@"gap Y %f", gapY);
    NSLog(@"gap X %f", gapX);
    CGPoint point = CGPointMake(0, 0);
    if (fabsf(gapX) > fabsf(gapY)) {
        if (gapX > 0) {
            if (gapX/2 * -1 >= gapY) {
                point = CGPointMake(-1, 1); //up right
            } else if (gapX/2 <= gapY){
                point = CGPointMake(1, 1);  //down right
            } else {
                point = CGPointMake(0, 1);  //right
            }
        } else if (gapX < 0) {
            if (gapX/2 >= gapY) {
                point = CGPointMake(-1, -1); //up left
            } else if (gapX/2 * -1 <= gapY){
                point = CGPointMake(1, -1); //down left
            } else {
                point = CGPointMake(0, -1); //left
            }
        }
    } else {
        if (gapY > 0) {
            if (gapY/2 <= gapX) {
                point = CGPointMake(1, 1);  // down right
            } else if (gapY/2 * -1 >= gapX){
                point = CGPointMake(1, -1); // down left
            } else {
                point = CGPointMake(1, 0);  //down
            }
        } else if (gapY < 0) {
            if (gapY/2 * -1 <= gapX) {
                point = CGPointMake(-1, 1); //up right
            } else if (gapY/2 >= gapX){
                point = CGPointMake(-1, -1);    //up left
            } else {
                point = CGPointMake(-1, 0); //up
            }
        }
    }
    
    if (!(self.previousFirstSlotPoint.x != firstSlotPoint.x && self.previousFirstSlotPoint.y != firstSlotPoint.y
        && self.previousMax != maxDistance
        && self.previousPoint.x != point.x && self.previousPoint.y != point.y)) {
        [self fillLine:firstSlotPoint
       directionalUnit:point
              distance:maxDistance];
        
        [self setNeedsDisplay];
    }
}

- (void)fillLine:(CGPoint)firstSlotPoint directionalUnit:(CGPoint)directionalUnit distance:(NSInteger)distance {
    NSLog(@"maxd %ld", (long)distance);
    // renew the line
    [self.slotSelection removeObjectsInRange:NSMakeRange(1, self.slotSelection.count-1)];
    
    // add line in the direction of the target slot
    for (int i = 1; i <= distance; i++) {
        SlotView *slotView = [self slotAtRow:firstSlotPoint.x + i * directionalUnit.x
                                      column:firstSlotPoint.y + i * directionalUnit.y];
        if (slotView != nil) {
            [self.slotSelection addObject:slotView];
        } else {
            break;
        }
    }
    self.previousFirstSlotPoint = firstSlotPoint;
    self.previousMax = distance;
    self.previousPoint = directionalUnit;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetPreviousLine];
    NSString *word = [self buildStringFromArray:self.slotSelection];
    self.firstLocation = CGPointZero;
    // check string
    self.hasCorrectMatch = [self checkSolution:word];
    if (!self.hasCorrectMatch) {
        // check reversed string
        word = [word reversedString];
        self.hasCorrectMatch = [self checkSolution:word];
    }
    
    if (!self.hasCorrectMatch) {
        [self.slotSelection removeAllObjects];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WORD_MATCHED object:word];
    }
    [self setNeedsDisplay];
}

- (NSString *)buildStringFromArray:(NSArray *)slotSelection {
    NSString *word = @"";
    for (int i = 0; i < slotSelection.count; i++) {
        SlotView *slotView = slotSelection[i];
        word = [NSString stringWithFormat:@"%@%@", word, slotView.labelView.text];
    }
    return word;
}

- (BOOL)checkSolution:(NSString *)word {
    return [[VocabularyManager instance] checkSolution:self.levelData word:word];
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
