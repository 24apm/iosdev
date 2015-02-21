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
#import "GameConstants.h"
#import "SoundManager.h"
#import "Utils.h"
#import "BaitView.h"
#import "CharacterView.h"


@interface BoardView()

@property (strong, nonatomic) NSMutableArray *slots;
@property (nonatomic) CGPoint firstLocation;
@property (nonatomic) CGPoint previousPoint;
@property (nonatomic) NSInteger previousMax;
@property (nonatomic) CGPoint previousFirstSlotPoint;
@property (strong, nonatomic) SlotView *previousSelectedSlotView;
@property (strong, nonatomic) NSMutableSet *finalSlotsSet;
@property (nonatomic, strong) SlotView *currentFinalSlot;
@property (strong, nonatomic) UIView *slotViewContainers;
@property (strong, nonatomic) CharacterView *character;
@property (strong, nonatomic) NSMutableArray *baitCache;
@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.slots = [NSMutableArray array];
        self.slotSelection = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.firstLocation = CGPointMake(0.f, 0.f);
        self.finalSlotsSet = [NSMutableSet set];
        self.slotViewContainers = [[UIView alloc] initWithFrame:self.bounds];
        self.slotViewContainers.backgroundColor = [UIColor clearColor];
        self.character = [[CharacterView alloc] init];
        self.baitCache = [NSMutableArray array];
        
        [self addSubview:self.slotViewContainers];
    }
    return self;
}

- (SlotView *)currentTarget {
    return [self closestFinalSlot];
}

- (SlotView *)closestFinalSlot {
    SlotView * slot = self.characterSlot;
    
    if (self.finalSlotsSet.count > 0) {
        slot = [self findClosestTargetSlot];
    }
    
    return slot;
}

- (BOOL)isThereTargetSlot {
    if (self.finalSlotsSet.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setupWithLevel:(LevelData *)levelData {
    self.levelData = levelData;
    [self.slotSelection removeAllObjects];
    
    float blockWidth = self.width / self.levelData.numColumn;
    self.slotSize = CGSizeMake(blockWidth, blockWidth);
    
    
    [self generateSlots];
    NSInteger x = [Utils randBetweenMinInt:0 max:NUM_COL -1];
    NSInteger y = [Utils randBetweenMinInt:0 max:NUM_ROW -1];
    SlotView *targetSlot = [self slotAtRow:x column:y];
    self.characterSlot = targetSlot;
    [self.characterSlot addSubview:self.character];
    [self refreshSlots];
}

- (void)refreshSlots {
    for (NSInteger i = 0; i < self.slots.count; i++) {
        SlotView *slotView = [self.slots objectAtIndex:i];
        slotView.labelView.text = @"";
    }
}

- (void)moveCharacterTo:(SlotView *)targetSlot {
    if (self.characterSlot != targetSlot) {
        CGPoint startPoint = [self gridPointForSlot:self.characterSlot];
        CGPoint endPoint = [self gridPointForSlot:targetSlot];
        CGPoint gapPoint = [self gapFrom:startPoint to:endPoint];
        CGPoint advancePoint;
        CGPoint newPoint;
        
        if (abs(gapPoint.x) > abs(gapPoint.y)) {
            advancePoint.x = [self advancePointFrom:startPoint.x to:endPoint.x];
        } else if (abs(gapPoint.y) > abs(gapPoint.x)) {
            advancePoint.y = [self advancePointFrom:startPoint.y to:endPoint.y];
        } else {
            NSInteger random = [Utils randBetweenMinInt:0 max:1];
            if (random == 0) {
                advancePoint.x = [self advancePointFrom:startPoint.x to:endPoint.x];
            } else {
                advancePoint.y = [self advancePointFrom:startPoint.y to:endPoint.y];
            }
        }
        newPoint.x = startPoint.x + advancePoint.x;
        newPoint.y = startPoint.y + advancePoint.y;
        SlotView *newSlot = [self slotAtRow:newPoint.x column:newPoint.y];
        self.characterSlot = newSlot;
        [self.characterSlot addSubview:self.character];
        
        if (self.characterSlot.bait != nil){
            [self.finalSlotsSet removeObject:self.currentFinalSlot];
            [self.baitCache addObject:self.characterSlot.bait];
            [self.characterSlot.bait removeFromSuperview];
            self.characterSlot.bait = nil;
        }
        
    }
}

- (CGPoint)gapFrom:(CGPoint)startPoint to:(CGPoint)endPoint {
    CGPoint gapPoint;
    gapPoint.x = endPoint.x - startPoint.x;
    gapPoint.y = endPoint.y - startPoint.y;
    return gapPoint;
}
- (NSInteger)advancePointFrom:(CGFloat)startPoint to:(CGFloat)endPoint {
    if (endPoint > startPoint) {
        return 1;
    } else {
        return -1;
    }
}

- (void)generateSlots {
    // remove old slots
    for (SlotView *slotView in self.slots) {
        [slotView removeFromSuperview];
    }
    [self.slots removeAllObjects];
    
    // renew slots
    for (NSInteger r = 0; r < self.levelData.numRow; r++) {
        for (NSInteger c = 0; c < self.levelData.numColumn; c++) {
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
    NSInteger row = (NSInteger)point.y / (NSInteger)self.slotSize.height;
    NSInteger col = (NSInteger)point.x / (NSInteger)self.slotSize.width;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    SlotView *slotView = [self slotAtScreenPoint:location];
    if (slotView == self.characterSlot || [self.finalSlotsSet containsObject:slotView] ) {
        return;
    }
    
    [slotView animateLabelSelection];
    if (self.baitCache.count <= 0) {
        [slotView createBait];
    } else {
        slotView.bait = [self.baitCache objectAtIndex:0];
        [slotView addSubview:[self.baitCache objectAtIndex:0]];
        [self.baitCache removeObjectAtIndex:0];
    }
    
    [self.finalSlotsSet addObject:slotView];
    //[self sortFinalSlotsArrayWith:slotView];
}

- (SlotView *)findClosestTargetSlot {
    SlotView * slotView;
    SlotView * targetSlot;
    CGPoint currentPoint = [self gridPointForSlot:self.characterSlot];
    CGPoint endPoint;
    NSInteger finalLocation;
    NSInteger finalBestLocation;
    
    for (SlotView *slot in self.finalSlotsSet) {
        
        targetSlot = slot;
        endPoint = [self gridPointForSlot:targetSlot];
        finalLocation = abs(currentPoint.x - endPoint.x) + abs(currentPoint.y - endPoint.y) ;
        if (finalLocation < finalBestLocation) {
            finalBestLocation = finalLocation;
            slotView = targetSlot;
            self.currentFinalSlot = slot;
        }
    }
    
    return slotView;
}

//- (void)sortFinalSlotsArrayWith:(SlotView *)slotView {
//    if (self.finalSlotsArray.count > 0) {
//        NSInteger index = 0;
//        SlotView * targetSlot;
//        CGPoint currentPoint = [self gridPointForSlot:self.characterSlot];
//        CGPoint newPoint = [self gridPointForSlot:slotView];
//        NSInteger newLocation = abs(currentPoint.x - newPoint.x) + abs(currentPoint.y - newPoint.y) ;
//        CGPoint endPoint;
//        NSInteger finalLocation;
//
//        for (NSInteger i = 0; i < self.finalSlotsArray.count; i++) {
//            targetSlot = [self.finalSlotsArray objectAtIndex:i];
//            endPoint = [self gridPointForSlot:targetSlot];
//            finalLocation = abs(currentPoint.x - endPoint.x) + abs(currentPoint.y - endPoint.y) ;
//            if (finalLocation > newLocation) {
//                break;
//            }
//            index++;
//        }
//
//        if (index < self.finalSlotsArray.count) {
//            [self.finalSlotsArray insertObject:slotView atIndex:index];
//        } else {
//            [self.finalSlotsArray addObject:slotView];
//        }
//    } else {
//        [self.finalSlotsArray addObject:slotView];
//    }
//}
@end
