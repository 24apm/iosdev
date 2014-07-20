//
//  HTTPRequest.m
//  TimedTap
//
//  Created by MacCoder on 3/28/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest()

@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation HTTPRequest

- (id)initWithURL:(NSString *)requestURL {
    self = [super init];
    if (self) {
        self.requestURL = requestURL;
    }
    return self;
}

- (void)send {
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:self.requestURL]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}

@end
