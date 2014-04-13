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

@interface GameLayoutView()

@property (nonatomic) int panNumbers;
@property (nonatomic) BOOL swipedBegan;

@end

@implementation GameLayoutView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // add pan recognizer to the view when initialized
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on
        self.panNumbers = 0;
        
        [self.boardView generateRandomTile];
        [self.boardView generateRandomTile];
        [UserData instance].currentScore = 0;
        
    }
    return self;
}

- (void)panRecognized:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // you might want to do something at the start of the pan
        self.swipedBegan = YES;
    }
    
    CGPoint distance = [sender translationInView:self]; // get distance of pan/swipe in the view in which the gesture recognizer was added
    CGPoint velocity = [sender velocityInView:self]; // get velocity of pan/swipe in the view in which the gesture recognizer was added
    float usersSwipeSpeed = abs(velocity.x); // use this if you need to move an object at a speed that matches the users swipe speed
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [sender cancelsTouchesInView]; // you may or may not need this - check documentation if unsure
        
        if (self.swipedBegan) {
            if (fabsf(distance.x) > fabsf(distance.y)) {
                if (distance.x > 0) { // right
                    [self.boardView shiftTilesRight];
                    NSLog(@"user swiped right");
                } else if (distance.x < 0) { //left
                    [self.boardView shiftTilesLeft];
                    NSLog(@"user swiped left");
                }
            } else {
                if (distance.y > 0) { // down
                    [self.boardView shiftTilesDown];
                    NSLog(@"user swiped down");
                } else if (distance.y < 0) { //up
                    [self.boardView shiftTilesUp];
                    NSLog(@"user swiped up");
                }
            }
            self.swipedBegan = NO;
            self.currentScore.text = [NSString stringWithFormat:@"Current Score: %.f",[UserData instance].currentScore];
        }
        //[self testRun];
        //NSLog(@"%d",self.panNumbers);
        // Note: if you don't want both axis directions to be triggered (i.e. up and right) you can add a tolerence instead of checking the distance against 0 you could check for greater and less than 50 or 100, etc.
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
