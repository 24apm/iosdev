//
//  BlockManager.m
//  StackGame
//
//  Created by MacCoder on 2/20/15.
//  Copyright (c) 2015 MacCoder. All rights reserved.
//

#import "BlockManager.h"

@implementation BlockManager

+ (UIColor *)colorForBlockType:(BlockType)type {
    UIColor *color = [UIColor clearColor];
    if (type == BlockType_Empty) {
        color = [UIColor clearColor];
    } else if (type == BlockType_Orange) {
        color = [UIColor orangeColor];
    } else if (type == BlockType_Apple) {
        color = [UIColor redColor];
    } else if (type == BlockType_Watermelon) {
        color = [UIColor greenColor];
    } else if (type == BlockType_Mango) {
        color = [UIColor brownColor];
    } else if (type == BlockType_Strawberry) {
        color = [UIColor magentaColor];
    } else if (type == BlockType_Pear) {
        color = [UIColor blueColor];
    } else if (type == BlockType_Grape) {
        color = [UIColor purpleColor];
    } else if (type == BlockType_Banana) {
        color = [UIColor yellowColor];
    } else if (type == BlockType_Cherry) {
        color = [UIColor lightGrayColor];
    } else if (type == BlockType_Lemon) {
        color = [UIColor cyanColor];
    } else {
        color = [UIColor clearColor];
    }
    return color;
}


@end
