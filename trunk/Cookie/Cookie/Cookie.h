//
//  Cookie.h
//  Cookie
//
//  Created by MacCoder on 9/12/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

@import SpriteKit;

static const NSUInteger NumCookieTypes = 6;

@interface Cookie : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSUInteger cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;
@end
