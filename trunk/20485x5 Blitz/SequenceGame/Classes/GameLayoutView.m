//
//  GameLayoutView.m
//  SequenceGame
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

@interface GameLayoutView()

@property (nonatomic) int panNumbers;
@property (nonatomic) BOOL swipedBegan;

@end

@implementation GameLayoutView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // add pan recognizer to the view when initialized
        
        
        // self.backgroundView.layer.cornerRadius = 20.f * IPAD_SCALE;
        //self.backgroundView.clipsToBounds = YES;
        //self.currentScore.layer.cornerRadius = 20.f * IPAD_SCALE;
    }
    return self;
}


- (void)awakeFromNib {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on
    self.panNumbers = 0;
    [[UserData instance] addObserver:self forKeyPath:@"currentScore" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[UserData instance] addObserver:self forKeyPath:@"currentCoin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayGameEnd) name:NO_MORE_MOVE_NOTIFICATION object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyPowerUp:) name:BUTTON_VIEW_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed:) name:BUY_POWER_CONFIRM_BUTTON_PRESSED_NOTIFICATION object:nil];
    
    [[GameData instance] resetCost];
    [self.buttonView1 setupWithType:ButtonViewTypeShuffle];
    [self.buttonView2 setupWithType:ButtonViewTypeBomb2];
    [self.buttonView3 setupWithType:ButtonViewTypeBomb4];
    [self.lostButtonView1 setupWithType:ButtonViewTypeLostShuffle];
    [self.lostButtonView2 setupWithType:ButtonViewTypeLostBomb2];
    [self.lostButtonView3 setupWithType:ButtonViewTypeLostBomb4];
}

- (void)buyPowerUp:(NSNotification *)notification {
    self.confirmMenu.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:CONFIRM_MENU_SHOWING object:notification];
    
}

- (IBAction)buyButtonPressed:(UIButton *)sender {
    [[CoinIAPHelper sharedInstance] showCoinMenu];
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

- (void)buttonPressed:(NSNotification *)notification {
    ButtonView *buttonView = notification.object;
    
    switch (buttonView.type) {
            
        case ButtonViewTypeShuffle:
            if([[PurchaseManager instance] purchasePowerUp:PowerUpTypeShuffle]) {
                [self.boardView shuffleTiles];
            }
            break;
            
        case ButtonViewTypeBomb2:
            if([self.boardView testTilesWith:2]){
                if([[PurchaseManager instance] purchasePowerUp:PowerUpTypeBomb2]) {
                    [self.boardView destroyTilesWith:2];
                }
            }
            break;
            
        case ButtonViewTypeBomb4:
            if([self.boardView testTilesWith:4]){
                if([[PurchaseManager instance] purchasePowerUp:PowerUpTypeBomb4]) {
                    [self.boardView destroyTilesWith:4];
                }
            }
            break;
            
        case ButtonViewTypeLostShuffle:
            if([[PurchaseManager instance] purchasePowerUp:PowerUpTypeRevive]) {
                [self.boardView shuffleTiles];
                [self hideGameEnd];
            }
            break;
            
        case ButtonViewTypeLostBomb2:
            if([self.boardView testTilesWith:2]){
           if([[PurchaseManager instance] purchasePowerUp:PowerUpTypeRevive]) {
                    [self.boardView destroyTilesWith:2];
                    [self hideGameEnd];
                }
            }
            break;
            
        case ButtonViewTypeLostBomb4:
            if([self.boardView testTilesWith:4]){
          if([[PurchaseManager instance] purchasePowerUp:PowerUpTypeRevive]) {
                    [self.boardView destroyTilesWith:4];
                    [self hideGameEnd];
                }
            }
            break;
            
        default:
            break;
    }
    [self refreshButtonViews];
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
@end
