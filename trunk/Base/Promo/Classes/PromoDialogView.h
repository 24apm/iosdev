//
//  PromoDialogView.h
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "XibDialogView.h"
#import "PromoIconView.h"

@interface PromoDialogView : XibDialogView

@property (strong, nonatomic) IBOutlet UIView *overlay;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutletCollection(PromoIconView) NSArray *promoIcons;

+ (void)show;

@end
