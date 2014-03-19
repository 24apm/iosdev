//
//  customizationItemView.h
//  SpeedyBnA
//
//  Created by MacCoder on 3/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"

typedef enum {
    CustomizationItemViewStateUnlocked,
    CustomizationItemViewStateEquipped,
    CustomizationItemViewStateLocked
} CustomizationItemViewState;

@interface CustomizationItemView : XibView

@property (strong, nonatomic) IBOutlet UIView *lockedView;
@property (strong, nonatomic) IBOutlet UIImageView *itemView;
@property (strong, nonatomic) IBOutlet UIView *equippedView;
@property (nonatomic) CustomizationItemViewState currentState;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *iapProductId;

- (void)setupWithDictionary:(NSDictionary *)dictionary;
- (void)refresh;

@end
