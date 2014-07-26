//
//  HTTPRequest.h
//  TimedTap
//
//  Created by MacCoder on 3/28/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)requestURL;
- (void)send;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
