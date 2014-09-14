//
//  PromoGameData.h
//  NumberGame
//
//  Created by MacCoder on 3/2/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoGameData : NSObject

@property (strong, nonatomic) NSString *bundleId;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *actionURL;

+ (PromoGameData *)setupWithBundleId:(NSString *)bundleId
                           imagePath:(NSString *)imagePath
                         description:(NSString *)description
                           actionURL:(NSString *)actionURL;

@end
