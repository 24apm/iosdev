//
//  GameViewControllerBase.m
//  TimedTap
//
//  Created by MacCoder on 3/29/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "GameViewControllerBase.h"
#import "PromoManager.h"
#import "AppInfoHTTPRequest.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface GameViewControllerBase ()

@property (nonatomic, retain) ADBannerView *adBannerView;
@property (strong, nonatomic) PromoBannerView *promoBannerView;

@end

@implementation GameViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Game Screen";
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"game_impression"     // Event category (required)
                                                          action:@"GameViewControllerBase"  // Event action (required)
                                                           label:[[NSBundle mainBundle] bundleIdentifier]          // Event label
                                                           value:nil] build]];    // Event value
    [self createAdBannerView];
    [self loadNextPromo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNextPromo) name:AppInfoHTTPRequestCallbackNotification object:nil];
}

- (AdBannerPositionMode)adBannerPositionMode {
    return AdBannerPositionModeBottom;
}

#pragma mark - ADs

- (void)createAdBannerView {
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        self.adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        self.adBannerView = [[ADBannerView alloc] init];
    }
    self.adBannerView.y = [self adBannerPositionOnScreen];
    self.adBannerView.delegate = self;
    
    // custom
    self.promoBannerView = [[PromoBannerView alloc] init];
    self.promoBannerView.frame = self.adBannerView.frame;
    self.promoBannerView.y = [self adBannerPositionOnScreen];
    self.promoBannerView.hidden = YES;
    [self.view addSubview:self.promoBannerView];
    [self.view addSubview:self.adBannerView];
}

- (CGFloat)adBannerPositionOnScreen {
    CGFloat yPosition;
    switch ([self adBannerPositionMode]) {
        case AdBannerPositionModeTop:
            yPosition = 0.f;
            break;
        case AdBannerPositionModeBottom:
            yPosition = self.view.height - self.adBannerView.height;
            break;
        default:
            break;
    }
    return yPosition;
}

- (CGFloat)adBannerPositionOffScreen {
    CGFloat yPosition;
    switch ([self adBannerPositionMode]) {
        case AdBannerPositionModeTop:
            yPosition = -self.adBannerView.height;
            break;
        case AdBannerPositionModeBottom:
            yPosition = self.view.height;
            break;
        default:
            break;
    }
    return yPosition;
}

- (void)layoutAnimated:(BOOL)animated {
    float bannerYOffset;
    if (NO &&self.adBannerView.bannerLoaded) {
        self.promoBannerView.hidden = YES;
        bannerYOffset = [self adBannerPositionOnScreen];
        //   bannerYOffset = self.view.height;
    } else {
        self.promoBannerView.hidden = NO;
        //  self.promoBannerView.hidden = YES;
        bannerYOffset = [self adBannerPositionOffScreen];
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.adBannerView.y = bannerYOffset;
    }];
}

- (void)loadNextPromo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadNextPromo) object:nil];
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

@end
