//
//  GameViewControllerBase.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameViewControllerBase.h"
#import "PromoBannerView.h"
#import "PromoManager.h"
#import "AppInfoHTTPRequest.h"

@interface GameViewControllerBase ()

@property (strong, nonatomic) PromoBannerView *promoBannerView;

@end

@implementation GameViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAdBannerView];
    [self loadNextPromo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNextPromo) name:AppInfoHTTPRequestCallbackNotification object:nil];
}

#pragma mark - ADs

- (void)createAdBannerView {
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        self.adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        self.adBannerView = [[ADBannerView alloc] init];
    }
    self.adBannerView.y = self.view.height - self.adBannerView.height;
    self.adBannerView.delegate = self;
    
    // custom
    self.promoBannerView = [[PromoBannerView alloc] init];
    self.promoBannerView.frame = self.adBannerView.frame;
    self.promoBannerView.y = self.view.height - self.promoBannerView.height;
    self.promoBannerView.hidden = YES;
    [self.view addSubview:self.promoBannerView];
    [self.view addSubview:self.adBannerView];
}

- (void)layoutAnimated:(BOOL)animated {
    float bannerYOffset;
    if (self.adBannerView.bannerLoaded) {
        self.promoBannerView.hidden = YES;
        bannerYOffset = self.view.height - self.adBannerView.height;
        //   bannerYOffset = self.view.height;
    } else {
        self.promoBannerView.hidden = NO;
        //  self.promoBannerView.hidden = YES;
        bannerYOffset = self.view.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.adBannerView.y = bannerYOffset;
    }];
}

- (void)loadNextPromo {
    [self.promoBannerView setupWithPromoGameData:[[PromoManager instance] nextPromo]];
    [self layoutAnimated:YES];
    [self performSelector:@selector(loadNextPromo) withObject:nil afterDelay:20.f];
}

#pragma mark - ADBannerViewDelegate

- (void)viewDidLayoutSubviews {
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutAnimated:YES];
}
/*
 - (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
 //tap on banner
 [self updateGameState:GameStatePauseMode];
 return  YES;
 }
 
 - (void)bannerViewActionDidFinish:(ADBannerView *)banner {
 [self updateGameState:GameStateResumeMode];
 }
 */

@end
