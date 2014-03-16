//
//  MonsterView.h
//  SequenceGame
//
//  Created by MacCoder on 3/14/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

@interface MonsterView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)refreshImage: (NSString *)imgName;

@end
