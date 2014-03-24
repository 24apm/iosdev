//
//  CustomizationView.m
//  SpeedyBnA
//
//  Created by MacCoder on 3/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CustomizationView.h"

@implementation CustomizationView

- (IBAction)backButtonPressed:(UIButton *)sender {
}

- (NSArray *)itemsData {
    NSMutableArray *itemsDataArr = [NSMutableArray array];
    // image
    // iAP id
    // iAP cost
    // name
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"sword.png", @"imagePath",
                                @"com.blahblah.firesword", @"iapProductId",
                                @"Fire Sword", @"itemName",
                                nil];
    [itemsDataArr addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"blah2.png", @"imagePath",
                  @"com.blahblah.firesword", @"iapProductId",
                  @"Fire Sword", @"itemName",
                  nil];
    [itemsDataArr addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"blah.png", @"imagePath",
                  @"com.blahblah.firesword", @"iapProductId",
                  @"Fire Sword", @"itemName",
                  nil];
    [itemsDataArr addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"blah.png", @"imagePath",
                  @"com.blahblah.firesword", @"iapProductId",
                  @"Fire Sword", @"itemName",
                  nil];
    [itemsDataArr addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"blah2.png", @"imagePath",
                  @"com.blahblah.firesword", @"iapProductId",
                  @"Fire Sword", @"itemName",
                  nil];
    [itemsDataArr addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"blah.png", @"imagePath",
                  @"com.blahblah.firesword", @"iapProductId",
                  @"Fire Sword", @"itemName",
                  nil];
    [itemsDataArr addObject:dictionary];
    return itemsDataArr;
}

- (void)show {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL complete) {
    }];
       [self refresh];
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.y = self.height;
    } completion:^(BOOL complete) {
        self.hidden = YES;
    }];
}
-(void)refresh {
    NSArray *itemsData = [self itemsData];
    for (int i = 0; i < self.itemViews.count; i++) {
        CustomizationItemView *itemView = [self.itemViews objectAtIndex:i];
        [itemView setupWithDictionary:[itemsData objectAtIndex:i]];
    }
}
@end
