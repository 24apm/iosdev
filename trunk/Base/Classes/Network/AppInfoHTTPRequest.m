//
//  AppInfoHTTPRequest.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "AppInfoHTTPRequest.h"
#import "PromoManager.h"

@implementation AppInfoHTTPRequest

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"artworkUrl60"];
        NSString *actionURL = [result objectForKey:@"trackViewUrl"];
        NSString *appName = [result objectForKey:@"trackName"];
        NSString *appBundleId = [result objectForKey:@"bundleId"];
        
        NSLog(@"appName: %@", appName);
        NSLog(@"icon: %@", icon);
        NSLog(@"actionURL: %@", actionURL);
        NSLog(@"appBundleId: %@", appBundleId);
        
        NSLog(@"\n\n");
        
        
        PromoGameData *promoData = [PromoGameData setupWithBundleId:appBundleId
                                                          imagePath:icon
                                                        description:appName
                                                          actionURL:actionURL];
        
        [[PromoManager instance] addPromo:promoData];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AppInfoHTTPRequestCallbackNotification object:nil];
}

@end
