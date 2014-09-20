//
//  GameScene.m
//  Cookie
//
//  Created by MacCoder on 9/12/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameScene.h"
#import "Cookie.h"
#import "Level.h"

static const CGFloat TileWidth = 32.0;
static const CGFloat TileHeight = 36.0;

@interface GameScene()

@property (strong, nonatomic) SKNode *gameLayer;
@property (strong, nonatomic) SKNode *cookiesLayer;
@property (strong, nonatomic) SKNode *tilesLayer;

@end

@implementation GameScene


- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    [self addChild:background];
    self.gameLayer = [SKNode node];
    [self addChild:self.gameLayer];
    
    CGPoint layerPosition = CGPointMake(-TileWidth*NumColumns/2, -TileHeight*NumRows/2);
    
    self.tilesLayer = [SKNode node];
    self.tilesLayer.position = layerPosition;
    [self.gameLayer addChild:self.tilesLayer];
    
    self.cookiesLayer = [SKNode node];
    self.cookiesLayer.position = layerPosition;
    [self.gameLayer addChild:self.cookiesLayer];
}

- (void)addTiles {
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if ([self.level tileAtColumn:column row:row] != nil) {
                SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                tileNode.position = [self pointForColumn:column row:row];
                [self.tilesLayer addChild:tileNode];
            }
        }
    }
}

- (void)addSpritesForCookies:(NSSet *)cookies {
    for (Cookie *cookie in cookies) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[cookie spriteName]];
        sprite.position = [self pointForColumn:cookie.column row:cookie.row];
        [self.cookiesLayer addChild:sprite];
        cookie.sprite = sprite;
    }
}

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}
@end