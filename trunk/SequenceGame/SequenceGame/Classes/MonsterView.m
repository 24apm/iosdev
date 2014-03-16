//
//  MonsterView.m
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "MonsterView.h"

@implementation MonsterView

- (void)refreshImage: (NSString *) imgName {
    self.imageView.image = [UIImage imageNamed:imgName];
}
@end
