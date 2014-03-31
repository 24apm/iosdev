//
//  PromoIconView.h
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "PromoGameData.h"

#define PROMO_ICON_CALLBACK @"PROMO_ICON_CALLBACK"

@interface PromoIconView : XibView

@property (strong, nonatomic) PromoGameData *promoGameData;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;

- (void)setupWithPromoGameData:(PromoGameData *)gameData;

@end
