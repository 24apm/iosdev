//
//  MonsterView.m
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "MonsterView.h"

@implementation MonsterView

- (void)setupWithMonsterData:(MonsterData *)data {
    self.data = data;
    self.imageView.image = [UIImage imageNamed:self.data.imagePath];
}

@end
