//
//  ButtonView.h
//  2048 5x5 Blitz
//
//  Created by MacCoder on 4/30/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "GameData.h"
#import "PurchaseManager.h"

#define BUTTON_VIEW_PRESSED @"BUTTON_VIEW_PRESSED"
#define CONFIRM_MENU_SHOWING @"CONFIRM_MENU_SHOWING"

typedef enum {
    ButtonViewTypeShuffle,
    ButtonViewTypeBomb2,
    ButtonViewTypeBomb4,
    ButtonViewTypeLostShuffle,
    ButtonViewTypeLostBomb2,
    ButtonViewTypeLostBomb4
} ButtonViewType;

@interface ButtonView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *glowEffect;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UIButton *buttonView;
@property (nonatomic) ButtonViewType type;
@property (nonatomic) PowerUpType powerType;
@property (strong, nonatomic) IBOutlet UIView *coinContainerView;

- (void)setupWithType:(ButtonViewType)type;
- (void)refresh;
- (int)priceCheck;

@end
