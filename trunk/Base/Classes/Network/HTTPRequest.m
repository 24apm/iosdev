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
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
}

@end
