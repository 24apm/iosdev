//
//  MonsterView.h
//  Game
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "MonsterData.h"

@interface MonsterView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) MonsterData *data;

- (void)setupWithMonsterData:(MonsterData *)data;

@end
