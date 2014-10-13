//
//  BufferedBoardView.h
//  Digger
//
//  Created by MacCoder on 9/21/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BufferedBoardView : UIView

@property (strong, nonatomic) NSArray *nextBufferedTypes;
@property (strong, nonatomic) NSArray *nextBufferedTiers;
@property (strong, nonatomic) NSArray *nextBufferedBlockTiers;

@property (strong, nonatomic) NSMutableArray *slots;

- (void)generateSlots;
- (void)generateBlocks;
- (BOOL)canGenerateNextRow;
- (void)generateNextRow;
- (void)reset;

@end
