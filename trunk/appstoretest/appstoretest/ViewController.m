//
//  ViewController.m
//  appstoretest
//
//  Created by MacCoder on 9/19/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Go to App Store" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0, 0.0, 200.0, 44.0)];
    [button setCenter:self.view.center];
    [self.view addSubview:button];
    
    // Add Target-Action Pair
    [button addTarget:self action:@selector(openAppStore:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)openAppStore:(id)sender {
    // Initialize Product View Controller
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    
    // Configure View Controller
    [storeProductViewController setDelegate:self];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"594467299"} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
            
        } else {
            // Present Store Product View Controller
            [self presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
