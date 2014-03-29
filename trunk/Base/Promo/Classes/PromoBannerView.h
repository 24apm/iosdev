//
//  PromoBannerView.h
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "PromoGameData.h"

@interface PromoBannerView : XibView

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *actionUrl;
@property (strong, nonatomic) NSString *bundleId;

- (void)setupWithPromoGameData:(PromoGameData *)gameData;

@end
