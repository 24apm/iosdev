//
//  BoardView.m
//  2048
//
//  Created by MacCoder on 4/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "BoardView.h"
#import "TileView.h"
#import "SlotView.h"
#import "Utils.h"
#import "UserData.h"
#import "GameConstants.h"
#import "AnimatedLabel.h"
#import "SoundManager.h"
#import "TrackUtils.h"
#import "PromoDialogView.h"

#define BOARD_ROWS 5
#define BOARD_COLS 5
#define DELAY_MERGE 0.4f
#define DELAY_NOMERGE 0.2f

@interface BoardView()

@property (nonatomic, retain) NSMutableArray *slots;
@property (nonatomic) BOOL hasMerge;
@property (nonatomic) BOOL hasMove;

@end

@implementation BoardView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundLayer.layer.cornerRadius = 10.f * IPAD_SCALE;
    self.backgroundLayer.clipsToBounds = YES;
}

- (void)generateNewBoard {
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tilePressed:) name:MAX_LEVEL_TILE_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:GAME_END_BUTTON_PRESSED_NOTIFICATION object:nil];
    [TrackUtils trackAction:@"GamePlay" label:@"GameStart"];
    [[UserData instance] retrieveUserCoin];
    [self unload];
    [self setupBoard];
    [self layoutSlots];
    [self generateRandomTile];
    [self generateRandomTile];
}

//- (void)tilePressed:(id)tile {
//    NSDictionary *dict = [tile userInfo];
//    TileView *pressedTile = [dict objectForKey:@"pressedTile"];
//    [UserData instance].currentScore = [UserData instance].currentScore + pressedTile.currentValue;
//    pressedTile = nil;
//}
- (void)unload {
    for (SlotView *slotView in self.slots) {
        [slotView unload];
    }
    self.slots = nil;
}

- (void)setupBoard {
    self.gameEnd = NO;
    SlotView *slot = nil;
    
    self.slots = [NSMutableArray array];
    
    for (int y = 0; y < BOARD_ROWS; y++) {
        for (int x = 0; x < BOARD_COLS; x++) {
            slot = [[SlotView alloc] init];
            [self.slots addObject:slot];
            [self.contentLayer addSubview:slot];
        }
    }
}

- (void)layoutSlots {
    SlotView *slot = [self slotAt:0 :0];
    
    float spaceWidth = self.width - slot.width * BOARD_COLS;
    spaceWidth = spaceWidth / (BOARD_COLS + 1);
    
    float spaceHeight = self.height - slot.height * BOARD_ROWS;
    spaceHeight = spaceHeight / (BOARD_ROWS + 1);
    
    for (int row = 0; row < BOARD_ROWS; row++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            slot = [self slotAt:row :col];
            slot.origin = CGPointMake(col * (slot.width + spaceWidth) + spaceWidth,
                                      row * (slot.height + spaceHeight) + spaceHeight);
        }
    }
}

- (void)generateRandomTile {
    SlotView *slot = [[self emptySlotArray] randomObject];
    [self generateTileForSlot:slot];
    
    SlotView *slot2 = [[self emptySlotArray] randomObject];
    [self generateTileForSlot:slot2];
    
    SlotView *slot3 = [[self emptySlotArray] randomObject];
    [self generateTileForSlot:slot3];
}

- (void)moveToNewSlot:(SlotView *)newSlot oldSlot:(SlotView *)oldSlot {
    if (newSlot == oldSlot) {
        return;
    }
    self.hasMove = YES;
    [self animateTile:oldSlot.tileView toSlot:newSlot];
    newSlot.tileView = oldSlot.tileView;
    oldSlot.tileView = nil;
}

- (void)mergeToNewSlot:(SlotView *)targetSlot currentSlot:(SlotView *)currentSlot {
    if (targetSlot == currentSlot || targetSlot.tileView.isMerged || !targetSlot.tileView.isMergeable || targetSlot.tileView.currentValue != currentSlot.tileView.currentValue) {
        return;
    }
    [self animateTileAndRemove:currentSlot.tileView toSlot:targetSlot];
    [targetSlot.tileView performSelector:@selector(animateMergedTile) withObject:nil afterDelay:TILE_MOVE_ANIMATION_DURATION];
    targetSlot.tileView.currentValue = targetSlot.tileView.currentValue + currentSlot.tileView.currentValue;
    [UserData instance].currentScore = [UserData instance].currentScore + targetSlot.tileView.currentValue;
    [self animateLabel:targetSlot.tileView.currentValue atSlot:targetSlot];
    targetSlot.tileView.isMerged = YES;
    currentSlot.tileView = nil;
    self.hasMerge = YES;
}

- (void)shiftTilesLeft {
    [self resetMerges];
    self.hasMerge = NO;
    self.hasMove = NO;
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeLeft = [self targetSlotForMergingLeftFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeLeft >= 0) {
                    SlotView *mergeSlot = [self slotAt:row :tagetSlotAfterMergeLeft];
                    [self mergeToNewSlot:mergeSlot currentSlot:slot];
                }
                int newSlotAfterMovingLeft = [self targetSlotForMovingLeftFromCurrentRow:row currentCol:col];
                SlotView *newSlot = [self slotAt:row :(newSlotAfterMovingLeft)];
                [self moveToNewSlot:newSlot oldSlot:slot];
                
            }
        }
    }
    if (self.hasMerge == YES || self.hasMove == YES) {
        if (self.hasMerge) {
            // [[SoundManager instance] play:SOUND_EFFECT_BUI];
            [[SoundManager instance] play:SOUND_EFFECT_BOILING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_MERGE];
        } else {
            [[SoundManager instance] play:SOUND_EFFECT_DUING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_NOMERGE];
        }
    }
}

- (void)shiftTilesRight {
    [self resetMerges];
    self.hasMerge = NO;
    self.hasMove = NO;
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = BOARD_COLS - 1; col >= 0; col--) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeRight = [self targetSlotForMergingRightFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeRight < BOARD_COLS) {
                    SlotView *mergeSlot = [self slotAt:row:tagetSlotAfterMergeRight];
                    [self mergeToNewSlot:mergeSlot currentSlot:slot];
                }
                int newSlotAfterMovingRight = [self targetSlotForMovingRightFromCurrentRow:row currentCol:col];
                SlotView *newSlot = [self slotAt:row :newSlotAfterMovingRight] ;
                [self moveToNewSlot:newSlot oldSlot:slot];
            }
        }
    }
    if (self.hasMerge == YES || self.hasMove == YES) {
        if (self.hasMerge) {
            //[[SoundManager instance] play:SOUND_EFFECT_BUI];
            [[SoundManager instance] play:SOUND_EFFECT_BOILING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_MERGE];
        } else {
            [[SoundManager instance] play:SOUND_EFFECT_DUING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_NOMERGE];
        }
    }
}

- (void)shiftTilesUp {
    [self resetMerges];
    self.hasMerge = NO;
    self.hasMove = NO;
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeUp = [self targetSlotForMergingUpFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeUp >= 0) {
                    SlotView *mergeSlot = [self slotAt:tagetSlotAfterMergeUp :col];
                    [self mergeToNewSlot:mergeSlot currentSlot:slot];
                    
                }
                int newSlotAfterMovingUp = [self targetSlotForMovingUpFromCurrentRow:row currentCol:col];
                SlotView *newSlot = [self slotAt:newSlotAfterMovingUp :col] ;
                [self moveToNewSlot:newSlot oldSlot:slot];
            }
        }
    }
    if (self.hasMerge == YES || self.hasMove == YES) {
        if (self.hasMerge) {
            // [[SoundManager instance] play:SOUND_EFFECT_BUI];
            [[SoundManager instance] play:SOUND_EFFECT_BOILING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_MERGE];
        } else {
            [[SoundManager instance] play:SOUND_EFFECT_DUING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_NOMERGE];
        }
    }
}

- (void)shiftTilesDown {
    [self resetMerges];
    self.hasMerge = NO;
    self.hasMove = NO;
    for (int row = BOARD_ROWS - 1; row >=  0; row --) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeDown = [self targetSlotForMergingDownFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeDown < BOARD_ROWS) {
                    SlotView *mergeSlot = [self slotAt:tagetSlotAfterMergeDown :col];
                    [self mergeToNewSlot:mergeSlot currentSlot:slot];
                    
                }
                int newSlotAfterMovingDown = [self targetSlotForMovingDownFromCurrentRow:row currentCol:col];
                SlotView *newSlot = [self slotAt:newSlotAfterMovingDown :col];
                [self moveToNewSlot:newSlot oldSlot:slot];
            }
        }
    }
    if (self.hasMerge == YES || self.hasMove == YES){
        if (self.hasMerge) {
            //[[SoundManager instance] play:SOUND_EFFECT_BUI];
            [[SoundManager instance] play:SOUND_EFFECT_BOILING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_MERGE];
        } else {
            [[SoundManager instance] play:SOUND_EFFECT_DUING];
            [self performSelector:@selector(generateRandomTile) withObject:nil afterDelay:DELAY_NOMERGE];
        }
    }
}

- (void)animateLabel:(int)value atSlot:(SlotView *)slot {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%d", value];
    label.center = slot.center;
    [label animate];
}

- (int)targetSlotForMovingLeftFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = 0;
    while ([self slotAt:currentRow :targetSlot].tileView != nil && targetSlot < currentCol) {
        targetSlot += 1;
    }
    return targetSlot;
}

- (int)targetSlotForMergingLeftFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = currentCol;
    targetSlot -= 1;
    
    if (targetSlot <= -1) {
        return targetSlot;
    }
    while (targetSlot >= 0 && [self slotAt:currentRow :targetSlot].tileView == nil ) {
        targetSlot -= 1;
    }
    return targetSlot;
}

- (int)targetSlotForMovingRightFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = BOARD_COLS - 1;
    while ([self slotAt:currentRow :targetSlot].tileView != nil && targetSlot > currentCol) {
        targetSlot -= 1;
    }
    return targetSlot;
}

- (int)targetSlotForMergingRightFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = currentCol;
    targetSlot += 1;
    
    if (targetSlot >= BOARD_COLS) {
        return targetSlot;
    }
    while (targetSlot < BOARD_COLS && [self slotAt:currentRow :targetSlot].tileView == nil) {
        targetSlot += 1;
    }
    
    return targetSlot;
}

- (int)targetSlotForMovingUpFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = 0;
    while ([self slotAt:targetSlot :currentCol].tileView != nil && targetSlot < currentRow) {
        targetSlot += 1;
    }
    return targetSlot;
}

- (int)targetSlotForMergingUpFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = currentRow;
    targetSlot -= 1;
    
    if (targetSlot <= -1) {
        return targetSlot;
    }
    
    while (targetSlot >= 0 && [self slotAt:targetSlot :currentCol].tileView == nil ) {
        targetSlot -= 1;
    }
    return targetSlot;
}

- (int)targetSlotForMovingDownFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = BOARD_ROWS - 1;
    while ([self slotAt:targetSlot :currentCol].tileView != nil && targetSlot > currentRow) {
        targetSlot -= 1;
    }
    return targetSlot;
}

- (int)targetSlotForMergingDownFromCurrentRow:(int)currentRow currentCol:(int)currentCol {
    int targetSlot = currentRow;
    targetSlot += 1;
    
    if (targetSlot >= BOARD_ROWS) {
        return targetSlot;
    }
    
    while (targetSlot < BOARD_ROWS && [self slotAt:targetSlot :currentCol].tileView == nil) {
        targetSlot += 1;
    }
    return targetSlot;
}

- (NSMutableArray *)emptySlotArray {
    NSMutableArray *emptyArray = [NSMutableArray array];
    for (SlotView *slot in self.slots) {
        if (!slot.tileView) {
            [emptyArray addObject:slot];
        }
    }
    return emptyArray;
}

- (void)generateTileForSlot:(SlotView *)slot {
    if (!slot) return;
    
    TileView *tile = [[TileView alloc] init];
    NSArray *randArr = @[@(2), @(4)];
    tile.currentValue = [[randArr randomObject] integerValue];
    [tile updateToRealLabel];
    slot.tileView = tile;
    [self.contentLayer addSubview:tile];
    tile.center = slot.center;
    [self scaleIn:tile];
    
    [self checkFullSlot];
}

- (void)scaleIn:(UIView *)view {
//    CAKeyframeAnimation *scaleIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    scaleIn.values = @[@(0.3f),@(1.2f),@(1.0f)];
//    scaleIn.keyTimes = @[@(0.0f),@(0.3f),@(1.0f)];

//    scaleIn.duration = TILE_MOVE_ANIMATION_DURATION;
    
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@(0.3f),@(1.0f),@(0.8f),@(1.0f)];
    opacity.duration = 0.5f;
    [view.layer addAnimation:opacity forKey:@"opacity"];
}

- (void)animateDestroyTile:(SlotView *)slot {
    
    CABasicAnimation *animateScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animateScale.toValue = [NSNumber numberWithFloat:1.4f];
    
    CABasicAnimation *animateOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateOpacity.toValue = [NSNumber numberWithFloat:0.3f];

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0f];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:rotationAnimation, animateScale, animateOpacity, nil];
    animateGroup.duration = TILE_MOVE_ANIMATION_DURATION + .2f;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    
    [slot.tileView.layer addAnimation:animateGroup forKey:@"animateDestroyTile"];
    [self performSelector:@selector(removeDestroyTile:) withObject:slot afterDelay:animateGroup.duration];
}

- (void)removeDestroyTile:(SlotView *)slot {
    [slot.tileView removeFromSuperview];
    slot.tileView = nil;
}

- (void)animateOffBoard:(SlotView *)slot {
    
    //    float x = [Utils randBetweenMin:0 max:self.width];
    //    float y = [Utils randBetweenMin:0 max:self.height];
    //
    //    CGPoint toPoint = CGPointMake(x, y);
    //
    [slot.tileView.layer removeAllAnimations];
    CGPoint toPoint = [slot.superview convertPoint:slot.center toView:slot.tileView.superview];
    
    CABasicAnimation *animatePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatePosition.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation *animateScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animateScale.toValue = [NSNumber numberWithFloat:1.2f];
    
    CABasicAnimation *animateOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateOpacity.toValue = [NSNumber numberWithFloat:0.6f];
    
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:animatePosition, animateScale, animateOpacity, nil];
    animateGroup.duration = TILE_MOVE_ANIMATION_DURATION;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    
    [slot.tileView.layer addAnimation:animateGroup forKey:@"animiateOffBoard"];
}

- (void)animateOnBoard:(SlotView *)slot {
    
    //    float x = [Utils randBetweenMin:0 max:self.width];
    //    float y = [Utils randBetweenMin:0 max:self.height];
    //
    //    CGPoint fromPoint = CGPointMake(x, y);
    CGPoint toPoint = [slot.superview convertPoint:slot.center toView:slot.tileView.superview];
    
    CABasicAnimation *animatePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatePosition.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CABasicAnimation *animateScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animateScale.fromValue = [NSNumber numberWithFloat:1.2f];
    animateScale.toValue = [NSNumber numberWithFloat:1.f];
    
    CABasicAnimation *animateOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateOpacity.toValue = [NSNumber numberWithFloat:1.f];
    
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:animatePosition, animateScale, animateOpacity, nil];
    animateGroup.duration = TILE_MOVE_ANIMATION_DURATION;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    
    [slot.tileView.layer addAnimation:animateGroup forKey:@"animiateOnBoard"];
    
    [self performSelector:@selector(scaleIn:) withObject:slot.tileView afterDelay:animateGroup.duration];
}

- (SlotView *)slotAt:(int)row :(int)col {
    return [self.slots objectAtIndex:col + row * BOARD_COLS];
}

- (void)animateTile:(TileView *)tile toSlot:(UIView *)slot  {
    [tile.layer removeAllAnimations];
    [tile.layer removeAnimationForKey:@"animateGroup"];
    CGPoint toPoint = [slot.superview convertPoint:slot.center toView:tile.superview];
    
    CABasicAnimation *animatePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatePosition.toValue = [NSNumber valueWithCGPoint:toPoint];
    
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = [NSArray arrayWithObjects:animatePosition, nil];
    animateGroup.duration = TILE_MOVE_ANIMATION_DURATION;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    [tile.layer addAnimation:animateGroup forKey:@"animateGroup"];
    
    [self performSelector:@selector(updateSlot:) withObject:slot afterDelay:animateGroup.duration];
}

- (void)animateTileAndRemove:(TileView *)tile toSlot:(UIView *)slot  {
    [self animateTile:tile toSlot:slot];
    [tile performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:TILE_MOVE_ANIMATION_DURATION];
}

- (void)updateSlot:(SlotView *)slot {
    [slot.tileView.layer removeAnimationForKey:@"animateGroup"];
    slot.tileView.center = [slot.superview convertPoint:slot.center toView:slot.tileView.superview];
}

- (void)resetMerges {
    for (SlotView * slot in self.slots) {
        slot.tileView.isMerged = NO;
    }
}

- (NSMutableArray *)storeCurrentTiles {
    NSMutableArray *currentTiles = [NSMutableArray array];
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                [self animateOffBoard:slot];
                [currentTiles addObject:slot.tileView];
                slot.tileView = nil;
            }
        }
    }
    return currentTiles;
}

- (void)shuffleTiles {
    NSMutableArray *storedTiles = [self storeCurrentTiles];
    float delay = .4f;
    
    [self performSelector:@selector(_shuffleTiles:) withObject:storedTiles afterDelay:delay];
    
}

- (void)_shuffleTiles:(NSMutableArray *)storedTiles {
    float delay = TILE_MOVE_ANIMATION_DURATION;
    float totalTime = 1.4f;
    float averageTime = totalTime / storedTiles.count;
    for (int i = 0; i < storedTiles.count; i++) {
        SlotView *slot = [[self emptySlotArray] randomObject];
        
        TileView *tile = [storedTiles objectAtIndex:i];
        slot.tileView.hidden = YES;
        slot.tileView = tile;
        [self.contentLayer addSubview:tile];
        tile.center = slot.center;
        //        [self scaleIn:tile];
        [self performSelector:@selector(animateOnBoard:) withObject:slot afterDelay:i * averageTime + delay];
        [self checkFullSlot];
    }
}

- (void)checkFullSlot {
    BOOL fullSlot = YES;
    for (SlotView *slot in self.slots) {
        if (!slot.tileView) {
            fullSlot = NO;
        }
    }
    if (fullSlot) {
        [self testForPossibleMove];
    }
}

- (void)destroyTilesWith:(int)number {
    float delay = .4f;

    [self performSelector:@selector(_destroyTilesWith:) withObject:[NSNumber numberWithInt:number] afterDelay:delay];
    
}

- (void)_destroyTilesWith:(NSNumber *)numberData {
    int number = [numberData intValue];
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                if (slot.tileView.currentValue == number) {
                     [self animateDestroyTile:slot];
                }
            }
        }
     }
}

- (BOOL)testTilesWith:(int)number {
    BOOL isNotOnlyTile = NO;
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                if (slot.tileView.currentValue != number) {
                    isNotOnlyTile = YES;
                }
            }
        }
    }
    return isNotOnlyTile;
}

- (void)testForPossibleMove {
    BOOL possibleMove = NO;
    
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeLeft = [self targetSlotForMergingLeftFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeLeft >= 0) {
                    SlotView *mergeSlot = [self slotAt:row :tagetSlotAfterMergeLeft];
                    if (mergeSlot != slot && mergeSlot.tileView.currentValue == slot.tileView.currentValue) {
                        possibleMove = YES;
                    }
                }
            }
        }
    }
    
    
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = BOARD_COLS - 1; col >= 0; col--) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeRight = [self targetSlotForMergingRightFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeRight < BOARD_COLS) {
                    SlotView *mergeSlot = [self slotAt:row:tagetSlotAfterMergeRight];
                    if (mergeSlot != slot && mergeSlot.tileView.currentValue == slot.tileView.currentValue) {
                        possibleMove = YES;
                    }
                }
            }
        }
    }
    for (int row = 0; row < BOARD_ROWS; row ++) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeUp = [self targetSlotForMergingUpFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeUp >= 0) {
                    SlotView *mergeSlot = [self slotAt:tagetSlotAfterMergeUp :col];
                    if (mergeSlot != slot && mergeSlot.tileView.currentValue == slot.tileView.currentValue) {
                        possibleMove = YES;
                    }
                }
            }
        }
    }
    
    for (int row = BOARD_ROWS - 1; row >=  0; row --) {
        for (int col = 0; col < BOARD_COLS; col++) {
            SlotView *slot = [self slotAt:row :col];
            if (slot.tileView) {
                int tagetSlotAfterMergeDown = [self targetSlotForMergingDownFromCurrentRow:row currentCol:col];
                if (tagetSlotAfterMergeDown < BOARD_ROWS) {
                    SlotView *mergeSlot = [self slotAt:tagetSlotAfterMergeDown :col];
                    if (mergeSlot != slot && mergeSlot.tileView.currentValue == slot.tileView.currentValue) {
                        possibleMove = YES;
                        
                    }
                }
            }
        }
    }
    if (!possibleMove) {
        // [self performSelector:@selector(dismissView) withObject:nil afterDelay:1.8f];
        NSLog(@"Good Game");
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_MORE_MOVE_NOTIFICATION object:self];

    }
}

- (void)dismissView{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:GAMEPLAY_VIEW_DISMISSED_NOTIFICATION object:self];
}
@end
