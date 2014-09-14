//
//  GameScene.h
//  Cookie
//

//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import SpriteKit;

@class Level;

@interface GameScene : SKScene

@property (strong, nonatomic) Level *level;

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;

@end
