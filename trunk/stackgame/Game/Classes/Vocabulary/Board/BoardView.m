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

@interface BoardView()

@property (strong, nonatomic) NSMutableArray *slots;

@property (strong, nonatomic) UIView *slotViewContainers;
@property (strong, nonatomic) NSMutableArray *matchedSetsArray;

@end

@implementation BoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.slots = [NSMutableArray array];
        self.slotSelection = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.matchedSetsArray = [NSMutableArray array];
        self.slotViewContainers = [[UIView alloc] initWithFrame:self.bounds];
        self.slotViewContainers.backgroundColor = [UIColor clearColor];
        [self addSubview:self.slotViewContainers];
        self.colPointer = 0;
        
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateAnswerIsOn) name:ANIMATE_CORRECT_WORD_NOTIFICATION object:nil];
    }
    return self;
}

- (void)setupWithLevel:(LevelData *)levelData {
    self.levelData = levelData;
    [self.slotSelection removeAllObjects];
    
    float blockWidth = self.width / self.levelData.numColumn;
    self.slotSize = CGSizeMake(blockWidth, blockWidth);
    
    [self generateSlots];
    [self refreshSlots];
}

- (void)refreshSlots {
    for (NSInteger i = 0; i < self.slots.count; i++) {
        SlotView *slotView = [self.slots objectAtIndex:i];
        [slotView.block blockLabelSetTo:@""];
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

- (NSString *)buildStringFromArray:(NSArray *)slotSelection {
    NSString *word = @"";
    for (NSInteger i = 0; i < slotSelection.count; i++) {
        SlotView *slotView = slotSelection[i];
        word = [NSString stringWithFormat:@"%@%@", word, slotView.block.label.text];
    }
    return word;
}

- (NSInteger)findEmptySlot {
    NSInteger index = self.slots.count - NUM_COL;
    index += self.colPointer;
    BOOL foundEmpty = NO;
    for (NSInteger i = 0; i < NUM_ROW; i++) {
        if ([self isSlotEmptyAt:index]) {
            foundEmpty = YES;
            break;
        }
        index -= NUM_COL;
    }
    return index;
}

- (BOOL)isSlotEmptyAt:(NSInteger)index {
    SlotView* currentSlot = [self.slots objectAtIndex:index];
    return [currentSlot.block.label.text isEqual:@""];
}

- (void)placeBlockWithTag:(NSString *)string {
    NSInteger emptySlotIndex = [self findEmptySlot];
    if (emptySlotIndex < 0) {
        NSInteger maxCheck = 0;
        
        while (maxCheck <= NUM_COL && emptySlotIndex < 0) {
            maxCheck ++;
            [self increaseColPointer];
            emptySlotIndex = [self findEmptySlot];
        }
        if (maxCheck >= NUM_COL) {
            return;
        }
    }
    if (emptySlotIndex < 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NO_MORE_MOVE object:nil];
        return;
    }
    SlotView* currentSlot = [self.slots objectAtIndex:emptySlotIndex];
    [currentSlot.block blockLabelSetTo:string];
    [self checkForMatchHori];
    [self checkForMatchVert];
    [self destroyBlocksfor:self.matchedSetsArray];
    [self shiftBlocksDown];
    [self increaseColPointer];
    
}

- (void)increaseColPointer {
    self.colPointer++;
    if (self.colPointer >= NUM_COL) {
        self.colPointer = 0;
    }
}

- (void)checkForMatchHori {
    for (NSInteger i = 0; i < NUM_ROW; i++) {
        for (NSInteger j = 0; j <= NUM_COL- MIN_SIZE_TO_MATCH; j++) {
            SlotView* currentSlot = [self slotAtRow:i column:j];
            if ([currentSlot.block.label.text isEqualToString:@""]) {
                continue;
            }
            
            NSInteger right = j;
            NSInteger numOfMatchingSet = 1;
            while (right++ < NUM_COL) {
                SlotView* nextSlot = [self slotAtRow:i column:right];
                if ([currentSlot.block.label.text isEqualToString:nextSlot.block.label.text]) {
                    numOfMatchingSet++;
                } else {
                    break;
                }
            }
            
            if (numOfMatchingSet >= MIN_SIZE_TO_MATCH) {
                SlotView* matchedSlot;
                for (NSInteger k = 0; k < numOfMatchingSet; k++) {
                    matchedSlot = [self slotAtRow:i column:k + j];
                    [self.matchedSetsArray addObject:matchedSlot];
                }
            }
        }
    }
}

- (void)checkForMatchVert {
    for (NSInteger i = 0; i <= NUM_ROW - MIN_SIZE_TO_MATCH; i++) {
        for (NSInteger j = 0; j < NUM_COL; j++) {
            SlotView* currentSlot = [self slotAtRow:i column:j];
            if ([currentSlot.block.label.text isEqualToString:@""]) {
                continue;
            }
            
            NSInteger down = i;
            NSInteger numOfMatchingSet = 1;
            while (down++ < NUM_ROW) {
                SlotView* nextSlot = [self slotAtRow:down column:j];
                if ([currentSlot.block.label.text isEqualToString:nextSlot.block.label.text]) {
                    numOfMatchingSet++;
                } else {
                    break;
                }
            }
            
            if (numOfMatchingSet >= MIN_SIZE_TO_MATCH) {
                SlotView* matchedSlot;
                for (NSInteger k = 0; k < numOfMatchingSet; k++) {
                    matchedSlot = [self slotAtRow:k + i column:j];
                    [self.matchedSetsArray addObject:matchedSlot];
                }
            }
        }
    }
}

//- (void)checkForMatch {
//    NSMutableArray *matchedBlocksSet = [NSMutableArray array];
//    for (NSInteger i = 0; i < NUM_ROW; i++) {
//        for (NSInteger j = 0; j < NUM_COL; j++) {
//            SlotView* currentSlot = [self slotAtRow:i column:j];
//            if ([currentSlot.block.label.text isEqualToString:@""]) {
//                continue;
//            }
//            [matchedBlocksSet addObject:currentSlot];
//            NSInteger up = i;
//            while (up-- > 0) {
//                SlotView* nextSlot = [self slotAtRow:up column:j];
//                if ([currentSlot.block.label.text isEqualToString:nextSlot.block.label.text]) {
//                    [matchedBlocksSet addObject:nextSlot];
//                } else {
//                    break;
//                }
//            }
//
//            NSInteger right = j;
//            while (right++ < NUM_COL) {
//                SlotView* nextSlot = [self slotAtRow:i column:right];
//                if ([currentSlot.block.label.text isEqualToString:nextSlot.block.label.text]) {
//                    [matchedBlocksSet addObject:nextSlot];
//                } else {
//                    break;
//                }
//            }
//        
//        if (matchedBlocksSet.count > 2) {
//            [self destroyBlocksfor:matchedBlocksSet];
//            [self shiftBlocksDown];
//        }
//        
//        [matchedBlocksSet removeAllObjects];
//    
//        }
//    }
//}


- (void)shiftBlocksDown {
    SlotView* currentSlot;
    SlotView* targetSlot;
    for (NSInteger i = NUM_ROW - 1; i >= 0; i--) {
        for (NSInteger j = NUM_COL - 1; j >= 0; j--) {
            currentSlot = [self slotAtRow:i column:j];
            if (![currentSlot.block.label.text isEqualToString:@""]) {
                continue;
            }
            NSInteger up = i;
            while (up > 0) {
                up--;
                targetSlot = [self slotAtRow:up column:j];
                if (![targetSlot.block.label.text isEqualToString:@""]) {
                    break;
                }
            }
            [currentSlot.block blockLabelSetTo:targetSlot.block.label.text];
            [targetSlot.block blockLabelSetTo:@""];
        }
    }
}

- (void)destroyBlocksfor:(NSMutableArray *)array {
    NSMutableArray *matchedBlocksSet = array;
    
    for (NSInteger j = 0; j < matchedBlocksSet.count; j++) {
        SlotView *slot = [matchedBlocksSet objectAtIndex:j];
        [slot.block blockLabelSetTo:@""];
    }
    [self.matchedSetsArray removeAllObjects];
}
@end
