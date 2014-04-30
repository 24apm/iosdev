//
//  PromoIconView.h
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "THLabel.h"
#import "PromoGameData.h"

#define IPAD_SCALE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0f : 1.0f)
#define PROMO_ICON_CALLBACK @"PROMO_ICON_CALLBACK"
#define ICON_PRESSED_NOTIFICATION @"ICON_PRESSED_NOTIFICATION"

@interface PromoIconView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *backViewImage;
@property (strong, nonatomic) IBOutlet THLabel *nameLabel;
@property (strong, nonatomic) PromoGameData *promoGameData;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (nonatomic) BOOL hasPressed;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

- (void)setupWithPromoGameData:(PromoGameData *)gameData;

@end
