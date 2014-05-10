//
//  GameLayoutView.m
//  Game
//
//  Created by MacCoder on 3/16/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AnimUtil.h"
#import "GameLayoutView.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "GameConstants.h"
#import "InGameMessageView.h"
#import "Utils.h"
#import "UserData.h"
#import "PromoDialogView.h"
#import "iRate.h"
#import "TrackUtils.h"
#import "GameData.h"
#import "CoinIAPHelper.h"
#import "ShopTableView.h"

@interface GameLayoutView()

@property (nonatomic) int panNumbers;
@property (nonatomic) BOOL swipedBegan;
@property (nonatomic, retain) ShopTableView *shopTableView;

@end

@implementation GameLayoutView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // add pan recognizer to the view when initialized
        
        self.coinContainer.layer.cornerRadius = 6.f * IPAD_SCALE;
    }
    return self;
}

- (void)createShopView {
    self.shopTableView = [[ShopTableView alloc] init];
    [self addSubview:self.shopTableView];
    [self.shopTableView setupWithItems:@[@"1",@"2",@"3"]];
    self.shopTableView.y = self.height;
}


- (void)awakeFromNib {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on
    self.panNumbers = 0;
    [[UserData instance] addObserver:self forKeyPath:@"currentScore" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"currentCoin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnd) name:NO_MORE_MOVE_NOTIFICATION object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyPowerUp:) name:BUTTON_VIEW_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPowerPressed:) name:BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION object:nil];
    
    [[GameData instance] resetCost];
    [self.buttonView1 setupWithType:ButtonViewTypeShuffle];
    [self.buttonView2 setupWithType:ButtonViewTypeBomb2];
    [self.buttonView3 setupWithType:ButtonViewTypeBomb4];
    [self.lostButtonView1 setupWithType:ButtonViewTypeLostShuffle];
    [self.lostButtonView2 setupWithType:ButtonViewTypeLostBomb2];
    [self.lostButtonView3 setupWithType:ButtonViewTypeLostBomb4];
    if (!self.shopTableView) {
        [self createShopView];
    }
}

- (void)buyPowerUp:(NSNotification *)notification {
    self.confirmMenu.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:CONFIRM_MENU_SHOWING object:notification];
    
}

- (IBAction)buyButtonPressed:(UIButton *)sender {
//    [[CoinIAPHelper sharedInstance] showCoinMenu];
    
    float yPos = self.height - self.shopTableView.height;
    [UIView animateWithDuration:0.3f animations:^ {
        self.shopTableView.y = yPos;
    }];
}


- (void)gameEnd {
    [self shakeScreen];
    [self performSelector:@selector(displayGameEnd) withObject:Nil afterDelay:0.7f];
}

- (void)displayGameEnd {
    self.fadeView.hidden = NO;
    self.endGameButton.hidden = NO;
    self.endGameImg.hidden = NO;
    
    self.boardView.anchorPoint = CGPointMake(0.f, 0.f);
    [UIView animateWithDuration:0.3f animations:^ {
        self.boardView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    }];
}

- (void)resetGameBoard {
    [UIView animateWithDuration:0.3f animations:^ {
        self.boardView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideGameEnd {
    self.fadeView.hidden = YES;
    self.endGameButton.hidden = YES;
    self.endGameImg.hidden = YES;
    self.boardView.anchorPoint = CGPointMake(0.f, 0.f);
    [self resetGameBoard];

}

- (IBAction)endGameButtonPressed:(id)sender {
    [[UserData instance] addNewScoreLocalLeaderBoard: [UserData instance].currentScore mode:GAME_MODE_VS];
    [[NSNotificationCenter defaultCenter] postNotificationName:GAME_END_BUTTON_PRESSED_NOTIFICATION object:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentCoin"])
    {
        float value = [[change objectForKey:NSKeyValueChangeNewKey]floatValue];
        self.coinLabel.text = [Utils formatWithComma:value];
    } else if([keyPath isEqualToString:@"currentScore"])
    {
        float value = [[change objectForKey:NSKeyValueChangeNewKey]floatValue];
        self.currentScore.text = [Utils formatWithComma:value];
    }
}

-(void)refreshButtonViews {
    [self.buttonView1 refresh];
    [self.buttonView2 refresh];
    [self.buttonView3 refresh];
    [self.lostButtonView1 refresh];
    [self.lostButtonView2 refresh];
    [self.lostButtonView3 refresh];
}

- (void)generateNewBoard {
    self.fadeView.hidden = YES;
    self.endGameButton.hidden = YES;
    self.endGameImg.hidden = YES;
    [UserData instance].currentScore = 0;
    self.boardView.transform = CGAffineTransformIdentity;
    [self.boardView generateNewBoard];
    [[GameData instance] resetCost];
    [self refreshButtonViews];
    self.confirmMenu.hidden = NO;
}

- (void)applyPowerUp:(ButtonView *)buttonView {

    switch (buttonView.type) {
            
        case ButtonViewTypeShuffle:
                [self.boardView shuffleTiles];
            break;
            
        case ButtonViewTypeBomb2:
            if([self.boardView testTilesWith:2]){
                    [self.boardView destroyTilesWith:2];
            }
            break;
            
        case ButtonViewTypeBomb4:
            if([self.boardView testTilesWith:4]){
                    [self.boardView destroyTilesWith:4];
            }
            break;
            
        case ButtonViewTypeLostShuffle:
            self.queuedPowerUp = buttonView;
                [self.boardView shuffleTiles];
                [self hideGameEnd];
            break;
            
        case ButtonViewTypeLostBomb2:
            self.queuedPowerUp = buttonView;
            if([self.boardView testTilesWith:2]){
                    [self.boardView destroyTilesWith:2];
                    [self hideGameEnd];
            }
            break;
            
        case ButtonViewTypeLostBomb4:
            self.queuedPowerUp = buttonView;
            if([self.boardView testTilesWith:4]){
                    [self.boardView destroyTilesWith:4];
                    [self hideGameEnd];
            }
            break;
            
        default:
            break;
    }
    [self refreshButtonViews];

}
- (void)buttonPowerPressed:(NSNotification *)notification {
    ButtonView *buttonView = notification.object;
    [self applyPowerUp:buttonView];
    
}
- (void)panRecognized:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // you might want to do something at the start of the pan
        self.swipedBegan = YES;
    }
    
    CGPoint distance = [sender translationInView:self]; // get distance of pan/swipe in the view in which the gesture recognizer was added
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [sender cancelsTouchesInView]; // you may or may not need this - check documentation if unsure
        
        float distanceTreshold = 10.f;
        if (self.swipedBegan) {
            if(fabsf(distance.x) > distanceTreshold || fabsf(distance.y) > distanceTreshold) {
                if (fabsf(distance.x) > fabsf(distance.y)) {
                    if (distance.x > 0) { // right
                        [self.boardView shiftTilesRight];
                    } else if (distance.x < 0) { //left
                        [self.boardView shiftTilesLeft];
                    }
                } else {
                    if (distance.y > 0) { // down
                        [self.boardView shiftTilesDown];
                    } else if (distance.y < 0) { //up
                        [self.boardView shiftTilesUp];
                    }
                }
                self.swipedBegan = NO;
            }
        }
    }
}

- (void)afterPurchasePowerUp:(NSNotification *)notification {
    NSString *productIdentifier = notification.object;
    [self animateCoin:[[CoinIAPHelper sharedInstance] valueForProductId:productIdentifier]];
    if (!self.queuedPowerUp) {
        [self applyPowerUp:self.queuedPowerUp];
    }
    self.queuedPowerUp = nil;
}

- (void)testRun {
    NSMutableArray *testMove = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i ++) {
        
        [testMove addObject:[NSString stringWithFormat:@"%d", i]];
    }
    int try = 0;
    while (try < 2 && !self.boardView.gameEnd) {
        self.panNumbers++;
        int testSwipe = [[testMove randomObject]intValue];
        switch (testSwipe) {
            case 0:
                [self.boardView shiftTilesLeft];
                NSLog(@"user swiped left");
                break;
            case 1:
                [self.boardView shiftTilesRight];
                NSLog(@"user swiped right");
                break;
            case 2:
                [self.boardView shiftTilesUp];
                NSLog(@"user swiped up");
                break;
            case 3:
                [self.boardView shiftTilesDown];
                NSLog(@"user swiped down");
                break;
            default:
                break;
        }
        try++;
    }
}

- (void)animateCoin:(int)value {
    AnimatedLabel *label = [[AnimatedLabel alloc] init];
    [self addSubview:label];
    label.label.text = [NSString stringWithFormat:@"+%d", value];
    label.center = self.coinLabel.center;
    [label animate];
}

- (void)shakeScreen {
    [AnimUtil wobble:self duration:0.1f angle:M_PI/128.f repeatCount:2];
}
@end
