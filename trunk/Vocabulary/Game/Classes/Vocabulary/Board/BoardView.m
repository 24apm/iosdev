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

@interface BoardDrawView : UIView

@property (strong, nonatomic) UIImage *cachedLineImage;
@property (strong, nonatomic) BoardView *boardView;

@end

@implementation BoardDrawView

- (instancetype)initWithBoardView:(BoardView *)boardView {
    self = [super init];
    if (self) {
        self.boardView = boardView;
    }
    return self;
}

- (void)cacheImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    self.cachedLineImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end the context
    UIGraphicsEndImageContext();
}

- (void)drawPath:(CGContextRef)context color:(CGColorRef)color lineWidth:(CGFloat)lineWidth {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGContextSetStrokeColorWithColor(context, color);
    bezierPath.lineWidth =  lineWidth;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    SlotView *slotView = [self.boardView.slotSelection objectAtIndex:0];
    
    [bezierPath moveToPoint:slotView.center];
    
    for (int i = 1; i < self.boardView.slotSelection.count; i++) {
        slotView = [self.boardView.slotSelection objectAtIndex:i];
        [bezierPath addLineToPoint:slotView.center];
    }
    
    slotView = [self.boardView.slotSelection lastObject];
    
    [bezierPath stroke];
}

- (void)drawSelectionStroke {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    [self.cachedLineImage drawInRect:self.bounds];
    
    if (self.boardView.slotSelection.count > 0) {
        
        UIColor *outerStrokeColor;
        UIColor *innerStrokeColor;
        
        if (self.boardView.hasCorrectMatch) {
            outerStrokeColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5f];
            innerStrokeColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5f];
        } else {
            outerStrokeColor = [UIColor colorWithRed:0 green:0 blue:1.f alpha:0.5f];
            innerStrokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5f];
        }
        
        [self drawPath:context color:outerStrokeColor.CGColor lineWidth:self.boardView.slotSize.width * 0.6f];
        
        if (self.boardView.hasCorrectMatch) {
            [self cacheImage];

            int index = 0;
            for (SlotView *slotView in self.boardView.slotSelection) {
                [slotView performSelector:@selector(animateLabelSelection) withObject:nil afterDelay:(float)index * 0.1f];
                index++;
            }
            [self.boardView.slotSelection removeAllObjects];
            self.boardView.hasCorrectMatch = NO;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawSelectionStroke];
}

- (void)refresh {
    [self setNeedsDisplay];
}

- (void)reset {
    self.cachedLineImage = nil;
}

@end


@interface BoardAnswerDrawView : UIView

@property (strong, nonatomic) BoardView *boardView;

@end

@implementation BoardAnswerDrawView

- (instancetype)initWithBoardView:(BoardView *)boardView {
    self = [super init];
    if (self) {
        self.boardView = boardView;
    }
    return self;
}

- (void)drawPath:(CGContextRef)context pathArr:(NSArray *)pathArr color:(CGColorRef)color lineWidth:(CGFloat)lineWidth {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGContextSetStrokeColorWithColor(context, color);
    bezierPath.lineWidth =  lineWidth;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    SlotView *slotView = [pathArr objectAtIndex:0];
    
    [bezierPath moveToPoint:slotView.center];
    
    for (int i = 1; i < pathArr.count; i++) {
        slotView = [pathArr objectAtIndex:i];
        [bezierPath addLineToPoint:slotView.center];
    }
    
    slotView = [pathArr lastObject];
    
    [bezierPath stroke];
}

- (void)drawSelectionStroke {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    UIColor *strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5f];
    
    
    for (NSArray *pointsArr in [self.boardView.levelData.answerIndexesToDrawGroup allValues]) {
        NSMutableArray *pathArr = [NSMutableArray array];
        for (NSValue *pointValue in pointsArr) {
            CGPoint point = [pointValue CGPointValue];
            SlotView *slotView = [self.boardView slotAtRow:point.x column:point.y];
            [pathArr addObject:slotView];
        }
        [self drawPath:context pathArr:pathArr color:strokeColor.CGColor lineWidth:self.boardView.slotSize.width * 0.6f];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawSelectionStroke];
}

@end


@interface BoardView()

@property (strong, nonatomic) NSMutableArray *slots;
@property (nonatomic) CGPoint firstLocation;
@property (nonatomic) CGPoint previousPoint;
@property (nonatomic) NSInteger previousMax;
@property (nonatomic) CGPoint previousFirstSlotPoint;
@property (strong, nonatomic) SlotView *previousSelectedSlotView;
@property (strong, nonatomic) BoardDrawView *boardDrawView;
@property (strong, nonatomic) BoardAnswerDrawView *boardAnswerDrawView;

@property (strong, nonatomic) UIView *slotViewContainers;

@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.slots = [NSMutableArray array];
        self.slotSelection = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.firstLocation = CGPointMake(0.f, 0.f);
        [self resetPreviousLine];
        
        self.slotViewContainers = [[UIView alloc] initWithFrame:self.bounds];
        self.slotViewContainers.backgroundColor = [UIColor clearColor];
        [self addSubview:self.slotViewContainers];
        
        // answer board
        self.boardAnswerDrawView = [[BoardAnswerDrawView alloc] initWithBoardView:self];
        self.boardAnswerDrawView.backgroundColor = [UIColor clearColor];
        self.boardAnswerDrawView.frame = CGRectMake(0.f, 0.f, self.width, self.height);
        [self addSubview:self.boardAnswerDrawView];
        self.boardAnswerDrawView.hidden = YES;
        
        // board draw view
        self.boardDrawView = [[BoardDrawView alloc] initWithBoardView:self];
        self.boardDrawView.backgroundColor = [UIColor clearColor];
        self.boardDrawView.frame = CGRectMake(0.f, 0.f, self.width, self.height);
        [self addSubview:self.boardDrawView];
        
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
    [self.boardDrawView reset];
    [self.slotSelection removeAllObjects];
    
    float blockWidth = self.width / self.levelData.numColumn;
    self.slotSize = CGSizeMake(blockWidth, blockWidth);
    
    self.boardAnswerDrawView.hidden = YES;
    
    [self generateSlots];
    [self refreshSlots];
    [self refresh];
}

- (void)refresh {
    [self.boardDrawView refresh];
}

- (void)refreshSlots {
    for (int i = 0; i < self.slots.count; i++) {
        SlotView *slotView = [self.slots objectAtIndex:i];
        NSString *letter = [self.levelData.letterMap objectAtIndex:i];
        slotView.labelView.text = letter;
    }
}

- (void)generateSlots {
    // remove old slots
    for (SlotView *slotView in self.slots) {
        [slotView removeFromSuperview];
    }
    [self.slots removeAllObjects];
    
    // renew slots
    for (int r = 0; r < self.levelData.numRow; r++) {
        for (int c = 0; c < self.levelData.numColumn; c++) {
            SlotView *slotView = [[SlotView alloc] init];
            slotView.frame = CGRectIntegral(CGRectMake(c * self.slotSize.width,
                                                       r * self.slotSize.height,
                                                       self.slotSize.width,
                                                       self.slotSize.height));
            slotView.userInteractionEnabled = NO;
            [self.slots addObject:slotView];
            [self.slotViewContainers addSubview:slotView];
        }
    }
}

- (SlotView *)slotAtScreenPoint:(CGPoint)point {
    NSInteger row = (int)point.y / (int)self.slotSize.height;
    NSInteger col = (int)point.x / (int)self.slotSize.width;
    return [self slotAtRow:row column:col];
}

- (SlotView *)slotAtRow:(NSInteger)r column:(NSInteger)c {
    if (r >= self.levelData.numRow || c >= self.levelData.numColumn || r < 0 || c < 0) {
        return nil;
    }
    NSUInteger index = r * self.levelData.numColumn + c;
    if (index < self.slots.count) {
        return [self.slots objectAtIndex:index];
    } else {
        return nil;
    }
}

- (CGPoint)gridPointForSlot:(SlotView *)slotView {
    NSUInteger index = [self.slots indexOfObject:slotView];
    NSUInteger r = index / self.levelData.numColumn;
    NSUInteger c = index % self.levelData.numColumn;
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
        [self refresh];
    }
}

- (void)showAnswer {
//    for (NSString *key in [self.levelData.answerIndexesToDrawGroup allKeys]) {
//        NSArray *indexes = [self.levelData.answerIndexesToDrawGroup objectForKey:key];
//        for (int i = 0; i < indexes.count; i++) {
//            CGPoint index = [[indexes objectAtIndex:i] CGPointValue];
//            SlotView *slotView = [self slotAtRow:index.x column:index.y];
//            slotView.backgroundColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.5f];
//            
//        }
//    }
    [self.boardAnswerDrawView setNeedsDisplay];
    self.boardAnswerDrawView.hidden = NO;
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
    
    if (self.previousMax != maxDistance
        || (self.previousPoint.x != point.x || self.previousPoint.y != point.y)) {
        [self fillLine:firstSlotPoint
       directionalUnit:point
              distance:maxDistance];
        
        [self refresh];
    }
}

- (void)fillLine:(CGPoint)firstSlotPoint directionalUnit:(CGPoint)directionalUnit distance:(NSInteger)distance {
    
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
    [self refresh];
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

@end
