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

#define TIMES_PLAYED_BEFORE_PROMO 3

@interface GameLayoutView()

@property (nonatomic) int panNumbers;
@property (nonatomic) BOOL swipedBegan;

@end

@implementation GameLayoutView

static int promoDialogInLeaderBoardCount = 0;

- (void)showPromoDialog {
    [TrackUtils trackAction:@"Gameplay" label:@"End"];
    promoDialogInLeaderBoardCount++;
    
    if (promoDialogInLeaderBoardCount % TIMES_PLAYED_BEFORE_PROMO == 0) {
        [PromoDialogView show];
    }
    [[iRate sharedInstance] logEvent:NO];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        // add pan recognizer to the view when initialized
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on
        self.panNumbers = 0;
        [[UserData instance] addObserver:self forKeyPath:@"currentScore" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayGameEnd) name:NO_MORE_MOVE_NOTIFICATION object:nil];
        self.backgroundView.layer.cornerRadius = 20.f * IPAD_SCALE;
        self.backgroundView.clipsToBounds = YES;
        self.currentScore.layer.cornerRadius = 20.f * IPAD_SCALE;
    }
    return self;
}

- (void)displayGameEnd {
    [self showPromoDialog];
    self.fadeView.hidden = NO;
    self.endGameButton.hidden = NO;
    self.endGameImg.hidden = NO;
}

- (IBAction)endGameButtonPressed:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_END_BUTTON_PRESSED_NOTIFICATION object:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScore"])
    {
        float value = [[change objectForKey:NSKeyValueChangeNewKey]floatValue];
            self.currentScore.text = [Utils formatWithComma:value];
    }
}

- (void)generateNewBoard {
    self.fadeView.hidden =YES;
    self.endGameButton.hidden = YES;
    self.endGameImg.hidden = YES;
    [UserData instance].currentScore = 0;
    [self.boardView generateNewBoard];
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
