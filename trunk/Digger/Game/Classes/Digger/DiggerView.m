//
//  DiggerView.m
//  Digger
//
//  Created by MacCoder on 9/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "DiggerView.h"
#import "GameConstants.h"
#import "LevelManager.h"
#import "BoardView.h"
#import "BoardManager.h"
#import "GridPoint.h"
#import "PromoDialogView.h"
#import "ProgressBarComponent.h"
#import "ObstacleView.h"
#import "PowerView.h"
#import "TreasureView.h"
#import "UserData.h"
#import "UpgradeShopDialogView.h"
#import "Utils.h"
#import "ShopTableView.h"
#import "WaypointView.h"
#import "CAEmitterHelperLayer.h"
#import "ChoiceDialogView.h"

typedef enum {
    DirectionLeft,
    DirectionRight,
    DirectionDown
} Direction;

@interface DiggerView()

@property (strong, nonatomic) BoardView *boardView;
@property (strong, nonatomic) IBOutlet UIView *boardLayer;
@property (strong, nonatomic) IBOutlet ProgressBarComponent *staminaBar;
@property (nonatomic) double playerMargin;
@property (strong, nonatomic) IBOutlet UILabel *depthLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coinImageView;
@property (strong, nonatomic) IBOutlet UIImageView *staminaImageView;
@property (strong, nonatomic) IBOutlet UILabel *staminaLabel;
@property (strong, nonatomic) IBOutlet UILabel *retryLabel;
@property (strong, nonatomic) IBOutlet UIButton *wayPoint;
@property (strong, nonatomic) IBOutlet UIButton *inventoryButton;
@property (nonatomic) BOOL tableViewOpen;
@property (nonatomic) TableType currentTableType;
@property (nonatomic, retain) ShopTableView *shopTableView;
@property (nonatomic) NSUInteger tempTreasure;
@property (nonatomic) BOOL isOverWeight;
@property (nonatomic, strong) UIImage *onQueueImage;
@property (nonatomic, strong) UIView *particleView;

@end

@implementation DiggerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slotPressed:) name:SLOTS_PRESSED_NOTIFICATION object:nil];
        self.particleView = [[UIView alloc]initWithFrame:CGRectMake(self.x, self.y, self.width, self.height)];
        [self addSubview:self.particleView];
        self.particleView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setup {
    self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(0, 0, self.boardLayer.size.width, self.boardLayer.size.height)];
    self.tableViewOpen = NO;
    [self.boardLayer addSubview:self.boardView];
    [self newGame];
    self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];
    self.retryLabel.text = [NSString stringWithFormat:@"Retry Left: %d", [UserData instance].retry];
    [self createShopView:self.currentTableType];
    //    [self.boardView addObserver:self forKeyPath:@"depth" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"retry" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movedToDepth:) name:WAYPOINT_ITEM_PRESSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dropItem:) name:INVENTORY_ITEM_DROP_PRESSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openFullInventory) name:REMOVING_ITEM_FOR_SPACE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closedInventory) name:    SHOP_TABLE_VIEW_NOTIFICATION_CLOSE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closingInventory) name:    FINISH_ANIMATING_ROW_REFRESH_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshStamina) name:    NOTIFICATION_REFRESH_STAMINA object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFullNotification:) name:    NOTIFICATION_KNAPSACK_FULL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animatePowerToIcon:) name:    NOTIFICATION_ANIMATE_POWER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateTreasureToIcon:) name:    NOTIFICATION_ANIMATE_TREASURE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveQueueImage:) name:    NOTIFICATION_ANIMATE_FOR_BLOCK_QUEUE object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"depth"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.depthLabel.text = [NSString stringWithFormat:@"Depth: %ld", (long)newC];
    } else if ([keyPath isEqualToString:@"coin"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.coinLabel.text = [NSString stringWithFormat:@"%ld", (long)newC];
    } else if ([keyPath isEqualToString:@"retry"]) {
        NSInteger newC = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        
        self.retryLabel.text = [NSString stringWithFormat:@"Retry Left: %d", newC];
    }
}

- (void)newGame {
    self.playerMargin = 0;
    [self.boardView newGame];
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen:YES];
    [self.boardView hideBoardLocalEmptyEffect:YES];
    [[UserData instance] refillStamina];
    [self refreshStamina];
    [[UserData instance] resetDepth];
    [self updateDepthLabel];
    
}

- (void)movedToDepth:(NSNotification *)notification {
    WaypointRowItem *item = notification.object;
    NSUInteger depthTarget = item.level + 1;
    [[UserData instance] resetDepth];
    [[UserData instance] incrementDepth:depthTarget];
    [self.boardView newGameWaypointTo:depthTarget];
    self.playerMargin = 0;
    [self.boardView refreshBoard];
    [self.boardView refreshBoardLocalOpen:YES];
    [self.boardView hideBoardLocalEmptyEffect:YES];
    [[UserData instance] refillStamina];
    [self refreshStamina];
    [self updateDepthLabel];
    
}

- (void)updateDepthLabel {
    self.depthLabel.text = [NSString stringWithFormat:@"Depth: %d",[UserData instance].currentDepth];
}

- (void)dropItem:(NSNotification *)notification {
    self.isOverWeight = NO;
    InventoryRowItem *item = notification.object;
    if ([[UserData instance] isKnapsackOverWeight]) {
        self.isOverWeight = YES;
    }
    [[UserData instance] removeKnapsackIndex:[item.itemId integerValue]];
    [self.shopTableView refreshInventory];
}

- (void)slotPressed:(NSNotification *)notification {
    SlotView *slotView = notification.object;
    [self handlePressed:slotView];
    
}

- (void)bombPressed:(SlotView *)slotView {
    [self.boardView findBombBlockOnSlot:slotView];
    [self.boardView cleanBombSet];
}

- (void)handlePressed:(SlotView *)slotView {
    // [self bombPressed:slotView];
    self.onQueueImage = nil;
    if ([self.boardView isNeighboringSlot:slotView]) {
        if ([self actionByBlockType:slotView]) {
            Direction currentDirection = [self drillDirectionTo:slotView];
            [self.boardView refreshBoardLocalOpen:NO];
            [self.boardView hideBoardLocalEmptyEffect:YES];
            [[BoardManager instance] movePlayerBlock:slotView];
            [self.boardView refreshBoardLocalOpen:YES];
            [self.boardView hideBoardLocalEmptyEffect:NO];
            
            if (currentDirection == DirectionDown && self.playerMargin >= 1) {
                [self.boardView generateBoardIfNecessary];
                self.boardView.depth++;
                [self.boardView shiftUp];
            }
            if (currentDirection == DirectionDown) {
                [UserData instance].currentDepth++;
                [self updateDepthLabel];
                self.playerMargin++;
            }
        }
        
        if (self.onQueueImage != nil) {
            [self animateParticleOnBlockPressed:self.onQueueImage];
        }
        
        if ([UserData instance].stamina <= 0) {
            [[UserData instance] decrementRetry];
            [[UserData instance]resetDepth];
            if (YES || [[UserData instance] hasRetry]) {
                [self.boardView hideBoardLocalEmptyEffect:YES];
                [self newGame];
            } else {
                self.boardView.userInteractionEnabled = NO;
            }
        }
    }
}

- (IBAction)wayPointButtonPressed:(UIButton *)sender {
    self.tableViewOpen = YES;
    self.currentTableType = TableTypeWaypoint;
    [self showTableView:sender tableType:self.currentTableType];
}

- (IBAction)inventoryButtonPressed:(UIButton *)sender {
    self.tableViewOpen = YES;
    self.currentTableType = TableTypeInventory;
    [self.shopTableView setupInventory];
    [self.shopTableView showTable];
    
}

- (void)showTableView:(UIButton *)button tableType:(TableType)type {
    //button.enabled = NO;
    [self.shopTableView setupWithType:type];
    [self.shopTableView showTable];
}

- (void)createShopView:(TableType)type {
    self.shopTableView = [[ShopTableView alloc] init];
    [self addSubview:self.shopTableView];
    
    NSArray *itemIds = [[TableManager instance] arrayOfitemIdsFor:type];
    [self.shopTableView setupWithItemIds:itemIds];
    self.shopTableView.y = self.height;
}

- (void)flyIconFrom:(UIImageView *)fromView toView:(UIImageView *)toView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:fromView.image];
    [self addSubview:imageView];
    imageView.frame = [fromView.superview convertRect:fromView.frame toView:imageView.superview];
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        imageView.frame = [toView.superview convertRect:toView.frame toView:imageView.superview];
    } completion:^(BOOL complete) {
        [imageView removeFromSuperview];
    }];
}

- (BOOL)actionByBlockType:(SlotView *)slotView {
    if (slotView.blockView) {
        return [slotView.blockView doAction:slotView];
    } else {
        return YES;
    }
}

- (void)openFullInventory {
    [[UserData instance] addKnapsackWith:self.tempTreasure];
    [self inventoryButtonPressed:nil];
}

- (void)closedInventory {
    [self cleanExtraInventoryItem];
}

- (void)closingInventory {
    if (self.isOverWeight) {
        [self.shopTableView closeTable];
    }
}

- (void)cleanExtraInventoryItem {
    while([[UserData instance] isKnapsackOverWeight]) {
        [[UserData instance] removeKnapsackIndex:[UserData instance].knapsack.count - 1];
    }
}

- (void)staminaBarDecrease:(NSUInteger)points {
    [[UserData instance] decrementStamina:points];
    [self refreshStamina];
}

- (void)staminaBarIncrease:(NSUInteger)points {
    [[UserData instance] incrementStamina:points];
    [self refreshStamina];
}

- (void)refreshStamina {
    self.staminaLabel.text = [NSString stringWithFormat:@"%lld/%lld", [UserData instance].stamina,[UserData instance].staminaCapacity];
    double percentage = [[UserData instance] formatPercentageStamina];
    
    [self staminaBarStatus:percentage];
    [self animateStaminaBar:percentage];
    
}

- (void)animateStaminaBar:(double)percentage {
    [UIView animateWithDuration:0.3f animations:^ {
        [self.staminaBar fillBar:percentage];
    }];
}

- (void)staminaBarStatus:(float)percentage {
    if (percentage <= .4f) {
        self.staminaBar.foregroundView.backgroundColor = [UIColor redColor];
    } else {
        self.staminaBar.foregroundView.backgroundColor = [UIColor greenColor];
    }
}

- (Direction)drillDirectionTo:(SlotView *)slotView {
    Direction direction = DirectionDown;
    GridPoint *playerPoint = [[BoardManager instance] pointForSlot:self.boardView.playerView.slotView];
    GridPoint *targetPoint = [[BoardManager instance] pointForSlot:slotView];
    if (playerPoint.col > targetPoint.col) {
        direction = DirectionLeft;
    } else if (playerPoint.col < targetPoint.col) {
        direction = DirectionRight;
    } else {
        direction = DirectionDown;
    }
    return direction;
}

- (IBAction)testButtonPressed:(id)sender {
    [[[UpgradeShopDialogView alloc] init] show];
}

- (void)showFullNotification:(NSNotification *)notification {
    self.tempTreasure = [notification.object integerValue];
    [[[ChoiceDialogView alloc]init] show];
}

- (void)animatePowerToIcon:(NSNotification *)notification {
    PowerView *targetView = notification.object;
    [self animateImageView:targetView.imageView toView:self.staminaImageView];
}

- (void)animateTreasureToIcon:(NSNotification *)notification {
    TreasureView *targetView = notification.object;
        //[self animateImageView:targetView.imageView toView:self.coinImageView];
        [self flyIconFrom:targetView.imageView toView:self.coinImageView];
}

- (void)animateImageView:(UIImageView *)image toView:(UIImageView *)view {
    [self animateBlocks:image toView:view];
    [self animateBlocks:image toView:view];
    [self animateBlocks:image toView:view];
}

- (void)animateBlocks:(UIImageView *)image toView:(UIImageView *)view {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffectLifeToIcon.json" onView:self.particleView];
    cellLayer.cellImage = image.image;
    [cellLayer refreshEmitter];
    
    CGPoint start = [image.superview convertPoint:image.center toView:self.particleView];
    
    CGPoint toPoint = [view.superview convertPoint:view.center toView:self.particleView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:start];
    
    CGFloat rand = arc4random() % (int)self.height;
    CGPoint c = CGPointMake(rand, rand);
    [path addQuadCurveToPoint:toPoint controlPoint:c];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    position.removedOnCompletion = NO;
    position.fillMode = kCAFillModeBoth;
    position.path = path.CGPath;
    position.duration = cellLayer.lifeSpan;
    [cellLayer addAnimation:position forKey:@"animateIn"];
    [self performSelector:@selector(refreshStamina) withObject:nil afterDelay:position.duration];
}

- (void)animateParticleOnBlockPressed:(UIImage *)image {
    CAEmitterHelperLayer *cellLayer = [CAEmitterHelperLayer emitter:@"particleEffect.json" onView:self.particleView];
    cellLayer.cellImage = image;
    [cellLayer refreshEmitter];
    cellLayer.emitterPosition = [self.boardView.playerView.superview convertPoint:self.boardView.playerView.center toView:self.particleView];
}

- (void)saveQueueImage:(NSNotification *)notification {
    UIImage *image = notification.object;
    self.onQueueImage = image;
}
@end
