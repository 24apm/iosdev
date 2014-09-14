//
//  Level.h
//  Cookie
//
//  Created by MacCoder on 9/12/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "Cookie.h"
#import "Tiles.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface Level : NSObject
- (instancetype)initWithFile:(NSString *)filename;
- (Tiles *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (NSSet *)shuffle;

- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;

@end
