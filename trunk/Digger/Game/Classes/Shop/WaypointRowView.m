//
//  ShopRowView.m
//  Clicker
//
//  Created by MacCoder on 5/10/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "WaypointRowView.h"
#import "UserData.h"
#import "GameConstants.h"
#import "Utils.h"
#import "CoinIAPHelper.h"

@implementation WaypointRowView

- (void)setupWithItem:(WaypointRowItem *)item {
    self.item = item;
    self.label.text = item.name;
    self.descriptionLabel.text = [item formatDescription];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", item.rank];
    self.imageView.image = [Utils imageNamed:[UIImage imageNamed:self.item.imagePath]
                                   withColor:[self.item tierColor:self.item.rank]
                                   blendMode:kCGBlendModeMultiply];
    self.rank = item.rank;
    if ([[UserData instance].waypointRank containsObject:[NSNumber numberWithInteger:item.rank]]) {
        self.overlayView.hidden = YES;
    } else {
        self.overlayView.hidden = NO;
    }
}
- (IBAction)buttonPressed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:WAYPOINT_ITEM_PRESSED_NOTIFICATION object:self.item];
}

@end
