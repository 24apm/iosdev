//
//  customizationItemView.m
//  SpeedyBnA
//
//  Created by MacCoder on 3/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CustomizationItemView.h"
#import "UserData.h"

@implementation CustomizationItemView

- (void)setupWithDictionary:(NSDictionary *)dictionary {
//    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                  @"blah.png", @"imagePath",
//                  @"com.blahblah.firesword", @"iapProductId",
//                  @"Fire Sword", @"itemName",
//                  nil];'
    
    self.iapProductId = [dictionary valueForKey:@"iapProductID"];
    self.itemView.image = [UIImage imageNamed:[dictionary valueForKey:@"imagePath"]];
    self.itemName = [dictionary valueForKey:@"itemName"];
}

- (void)refresh {
    self.equippedView.hidden = YES;
    self.lockedView.hidden = YES;
    switch (self.currentState) {
        case CustomizationItemViewStateEquipped:
            self.equippedView.hidden = NO;
            break;
        case CustomizationItemViewStateLocked:
            self.lockedView.hidden = NO;
            break;
        default:
            break;
    }
}
- (IBAction)lockedViewPressed:(id)sender {
    self.currentState = CustomizationItemViewStateUnlocked;
    [UserData instance].currentEquippedItem = self.itemName;
    [self refresh];
}

@end
