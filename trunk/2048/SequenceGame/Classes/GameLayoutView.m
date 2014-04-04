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

@interface GameLayoutView()

@end

@implementation GameLayoutView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // add pan recognizer to the view when initialized
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on
    }
    return self;
}

- (void)panRecognized:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // you might want to do something at the start of the pan
    }
    
    CGPoint distance = [sender translationInView:self]; // get distance of pan/swipe in the view in which the gesture recognizer was added
    CGPoint velocity = [sender velocityInView:self]; // get velocity of pan/swipe in the view in which the gesture recognizer was added
    float usersSwipeSpeed = abs(velocity.x); // use this if you need to move an object at a speed that matches the users swipe speed
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [sender cancelsTouchesInView]; // you may or may not need this - check documentation if unsure
        if (distance.x > 0) { // right
            NSLog(@"user swiped right");
        } else if (distance.x < 0) { //left
            NSLog(@"user swiped left");
        }
        if (distance.y > 0) { // down
            NSLog(@"user swiped down");
        } else if (distance.y < 0) { //up
            NSLog(@"user swiped up");
        }
        [self.boardView generateRandomTile];
        // Note: if you don't want both axis directions to be triggered (i.e. up and right) you can add a tolerence instead of checking the distance against 0 you could check for greater and less than 50 or 100, etc.
    }
}

@end
