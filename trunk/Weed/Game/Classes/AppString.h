//
//  AppString.h
//  Weed
//
//  Created by MacCoder on 7/17/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VISITOR_BUYER_SUCCESS_HEADER @"YAY!"
#define VISITOR_BUYER_SUCCESS_MESSAGE @"You just sold your house!"

#define VISITOR_BUYER_CONFIRM_HEADER @"Confirm"
#define VISITOR_BUYER_CONFIRM_MESSAGE @"Are you sure you want to sell this house?"

#define VISITOR_BUYER_FAILED_HEADER @"Uh oh!"
#define VISITOR_BUYER_FAILED_MESSAGE @"Don't sell away your last house!"

#define VISITOR_REAL_ESTATE_SUCCESS_HEADER @"YAY!"
#define VISITOR_REAL_ESTATE_SUCCESS_MESSAGE @"You just purchased the house! Once tenants move in, you will start to earn rent!"

#define VISITOR_REAL_ESTATE_FAILED_MONEY_HEADER @"Uh oh!"
#define VISITOR_REAL_ESTATE_FAILED_MONEY_MESSAGE @"The house is too expensive!"

#define VISITOR_REAL_ESTATE_FAILED_HOUSE_LIMIT_HEADER @"Uh oh!"
#define VISITOR_REAL_ESTATE_FAILED_HOUSE_LIMIT_MESSAGE @"You have no more room for this house! You must sell one of your houses to make more room!"

#define HOUSE_COLLECT_FAILED_HEADER @"Uh oh!"
#define HOUSE_COLLECT_FAILED_MESSAGE @"Rent is not ready yet!"

#define HOUSE_EMPTY_HEADER @"Uh oh!"
#define HOUSE_EMPTY_MESSAGE @"This house is empty. You need to find a renter first to start collecting rent!"

#define HOUSE_RENTER_ADDED_HEADER @"YAY!"
#define HOUSE_RENTER_ADDED_MESSAGE @"Your new tenant has moved into this house. You can now start to collect rent!!"

#define HOUSE_RENTER_CONTRACT_EXPIRED_HEADER @"Oh no!"
#define HOUSE_RENTER_CONTRACT_EXPIRED_MESSAGE @"Tenant has moved out of house #%d"

#define HOUSE_RENTER_HOUSE_NOT_LARGE_ENOUGH_HEADER @"Uh oh!"
#define HOUSE_RENTER_HOUSE_NOT_LARGE_ENOUGH_MESSAGE @"This house is not large enough!!"

#define HOUSE_RENTER_REPLACE_HEADER @"Uh oh!"
#define HOUSE_RENTER_REPLACE_MESSAGE @"Are you sure you want to replace your renter?"

#define EDIT_MODE_MESSAGE @"Choose a house for this potential tenant! \nTenants: %1$d \nRental: %2$@"

@interface AppString : NSObject

@end
