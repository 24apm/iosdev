//
//  ParallaxWorldView.m
//  Weed
//
//  Created by MacCoder on 7/6/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ParallaxWorldView.h"
#import "ParallaxBackgroundView.h"
#import "ParallaxForegroundView.h"
#import "Utils.h"
#import "CustomGameLoopTimer.h"
#import "UserData.h"
#import "RealEstateManager.h"
#import "AppString.h"
#import "MessageDialogView.h"
#import "VisitorManager.h"
#import "BuyerVisitorData.h"
#import "ErrorDialogView.h"
#import "CoinIAPHelper.h"
#import "ShopTableView.h"
#import "AnimatedLabel.h"

@interface ParallaxWorldView()

@property (strong, nonatomic) NSMutableArray *parallaxViews;
@property (strong, nonatomic) ParallaxBackgroundView *backgroundView;
@property (strong, nonatomic) ParallaxForegroundView *foregroundView;
@property (strong, nonatomic) NSTimer *userPassiveTimer;
@property (nonatomic, retain) ShopTableView *shopTableView;

@end

@implementation ParallaxWorldView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parallaxViews = [NSMutableArray array];
        
        self.backgroundView = [[ParallaxBackgroundView alloc] init];
        [self.parallaxViews addObject:self.backgroundView];
        [self.containerView addSubview:self.backgroundView];
        
        self.foregroundView = [[ParallaxForegroundView alloc] init];
        [self.containerView addSubview:self.foregroundView];
        
        self.foregroundView.scrollView.delegate = self;
        
    }
    return self;
}

- (void)setup {
    [self.backgroundView setup];
    [self.foregroundView setup];
    self.coinLabel.text = [NSString stringWithFormat:@"%lld", [UserData instance].coin];
    self.coinGainLabel.alpha = 0.f;
    self.editModeView.hidden = YES;
    self.exitEditModebutton.hidden = YES;
    self.coinAlertButton.hidden = YES;
    
    [[UserData instance] addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [[RealEstateManager instance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateCoinToHud:) name:kHouseViewCollectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToNewHouse) name:PURCHASED_HOUSE_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soldHouse:) name:SOLD_HOUSE_NOTIFICATION object:nil];
    
    self.userPassiveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateUserPassive) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:DRAW_STEP_NOTIFICATION object:nil];
}

- (void)updateUserPassive {
    // update passive
    [[UserData instance] addUserPassive];
}

- (void)refresh {
    // pulse coin
    if ([[RealEstateManager instance] canCollectAnyHouseMoney]) {
        if (self.coinAlertButton.hidden) {
            [self pulseCoinAlert];
        }
    } else {
        if (!self.coinAlertButton.hidden) {
            [self hideCoinAlert];
        }
    }
}

- (void)animateCoinToHud:(NSNotification *)notification {
    HouseView *houseView = notification.object;
    
    UIImageView *tempCoinImageView = [[UIImageView alloc] init];
    tempCoinImageView.frame = houseView.coinImageView.frame;
    tempCoinImageView.image = houseView.coinImageView.image;
    [self addSubview:tempCoinImageView];
    
    CGPoint startPosition = [houseView.coinImageView.superview convertPoint:houseView.coinImageView.center toView:tempCoinImageView.superview];
    tempCoinImageView.center = startPosition;
    
    CGPoint targetView = [self.coinImageView.superview convertPoint:self.coinImageView.center toView:tempCoinImageView.superview];
    
    self.coinGainLabel.text = [NSString stringWithFormat:@"+%lld", houseView.data.renterData.cost];
    [self.coinGainLabel.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.5f animations:^ {
        tempCoinImageView.center = targetView;
    }completion:^(BOOL completed) {
        [tempCoinImageView removeFromSuperview];
        [self animateCoinLabel];
    }];
    
}

- (void)hideCoinAlert {
    self.coinAlertButton.hidden = YES;
    [self.coinAlertButton.layer removeAllAnimations];
}

- (IBAction)scrollToFirstCollectableHouse:(id)sender {
    // [[[MessageDialogView alloc] initWithHeaderText:HOUSE_FINDER
    //                                     bodyText:[NSString stringWithFormat:HOUSE_FINDER_MESSAGE,10]] show];
    //    HouseView *house = [self.foregroundView firstCollectableHouse];
    //    [self scrollToHouse:house];
}

- (void)scrollToNewHouse {
    HouseView *house = [self.foregroundView newestHouse];
    [self scrollToHouse:house];
    [[NSNotificationCenter defaultCenter] postNotificationName:VIEWING_NEW_HOUSE_NOTIFICATION object:nil];
}

- (void)soldHouse:(NSNotification *)notification {
    NSString *houseCost = notification.object;
    self.coinGainLabel.text = houseCost;
    [self animateCoinLabel];
}

- (void)pulseCoinAlert {
    self.coinAlertButton.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25f;
    animation.toValue = @(1.2f);
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    [self.coinAlertButton.layer addAnimation:animation forKey:@"popIn"];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = 0.8f;
    alphaAnimation.toValue = @(1);
    alphaAnimation.repeatCount = HUGE_VALF;
    alphaAnimation.autoreverses = YES;
    [self.coinAlertButton.layer addAnimation:alphaAnimation forKey:@"alphaIn"];
}

- (void)animateCoinLabel {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25f;
    animation.toValue = @(1.6f);
    animation.autoreverses = YES;
    [self.coinGainLabel.layer addAnimation:animation forKey:@"popIn"];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = 0.8f;
    alphaAnimation.toValue = @(1);
    alphaAnimation.autoreverses = YES;
    [self.coinGainLabel.layer addAnimation:alphaAnimation forKey:@"alphaIn"];
}

- (void)animateCoinLabelForHouse {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25f;
    animation.toValue = @(1.6f);
    animation.autoreverses = YES;
    [self.coinGainLabel.layer addAnimation:animation forKey:@"popIn"];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = 0.8f;
    alphaAnimation.toValue = @(1);
    alphaAnimation.autoreverses = YES;
    [self.coinGainLabel.layer addAnimation:alphaAnimation forKey:@"alphaIn"];
}

- (void)scrollToHouse:(HouseView *)houseView {
    [self.foregroundView.scrollView scrollRectToVisible:CGRectMake(houseView.center.x - self.width * 0.5f, self.foregroundView.scrollView.y, self.foregroundView.scrollView.width, self.foregroundView.scrollView.height) animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"coin"]) {
        id newValue = [object valueForKeyPath:keyPath];
        self.coinLabel.text = [NSString stringWithFormat:@"%d", [newValue integerValue]];
    } else if ([keyPath isEqual:@"state"]) {
        RealEstateManagerState newValue = [[object valueForKeyPath:keyPath] integerValue];
        self.headerView.hidden = YES;
        self.exitEditModebutton.hidden = YES;
        self.editModeView.hidden = YES;
        
        switch (newValue) {
            case RealEstateManagerStateNormal:
                self.headerView.hidden = NO;
                break;
            case RealEstateManagerStateEdit: {
                self.exitEditModebutton.hidden = NO;
                self.editModeView.hidden = NO;
                RenterData *renterData = [RealEstateManager instance].currentRenterData.renterData;
                HouseView *firstEmptyHouse = [self.foregroundView firstEmptyHouseUnder:renterData.count];
                [self scrollToHouse:firstEmptyHouse];
                NSString *rentalRate = [NSString stringWithFormat:@"$%lld per %@", renterData.cost, [Utils formatTime:renterData.duration]];
                
                self.editModeMessage.text = [NSString stringWithFormat:EDIT_MODE_MESSAGE,
                                             [RealEstateManager instance].currentRenterData.renterData.count,
                                             rentalRate];
                break;
            }
            default:
                break;
        }
        [self.foregroundView refreshHouses];
    }
}
- (IBAction)resetUserData:(id)sender {
    [[UserData instance] resetUserData];
}

- (IBAction)exitEditModebuttonPressed:(id)sender {
    [RealEstateManager instance].state = RealEstateManagerStateNormal;
    [RealEstateManager instance].currentRenterData = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentageOffsetX = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.width);
    
    for (UIView *view in self.parallaxViews) {
        view.x = -(view.width - scrollView.width) * percentageOffsetX ;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [self hitTest:self point:point withEvent:event];
    if (view) {
        return view;
    } else {
        return [super hitTest:point withEvent:event];
    }
}
- (IBAction)leftPressed:(id)sender {
    CGRect rect = self.foregroundView.scrollView.frame;
    rect.origin.x = 0;
    [self.foregroundView.scrollView scrollRectToVisible:rect animated:YES];
}

- (IBAction)rightPressed:(id)sender {
    CGRect rect = self.foregroundView.scrollView.frame;
    rect.origin.x = self.foregroundView.scrollView.contentSize.width - self.foregroundView.scrollView.frame.size.width;
    [self.foregroundView.scrollView scrollRectToVisible:rect animated:YES];
    
}
- (IBAction)sellerVistorPressed:(id)sender {
    if (self.editModeView.hidden == NO) {
        return;
    }
    [[[VisitorManager instance] dialogFor:[RealEstateVisitorData dummyData]] show];
}
- (IBAction)buyerVisitorPressed:(id)sender {
    if (self.editModeView.hidden == NO) {
        return;
    }
    if ([[RealEstateManager instance] canSellHouse]) {
        [[[VisitorManager instance] dialogFor:[BuyerVisitorData dummyData]] show];
    } else {
        [[[MessageDialogView alloc] initWithHeaderText:VISITOR_BUYER_FAILED_HEADER bodyText:VISITOR_BUYER_FAILED_MESSAGE] show];
    }
}
- (IBAction)powerPressed:(id)sender {
    if (self.editModeView.hidden == NO) {
        return;
    }
    if ([CoinIAPHelper sharedInstance].hasLoaded) {
        [self.shopTableView setupWithType:POWER_UP_TYPE_IAP];
    } else {
        [[[ErrorDialogView alloc] init] show];
    }
}

- (UIView *)hitTest:(UIView *)someView point:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSMutableArray *queue = [NSMutableArray array];
    [queue addObject:someView];
    
    UIView *rootView;
    while (queue.count > 0) {
        rootView = [queue firstObject];
        [queue removeObjectAtIndex:0];
        
        for (UIView *view in rootView.subviews) {
            [queue addObject:view];
        }
        
        if ([rootView isKindOfClass:[UIButton class]]) {
            CGPoint pointInButton = [rootView convertPoint:point fromView:self];
            if ([rootView pointInside:pointInButton withEvent:event]) {
                return rootView;
            }
        }
    }
    return nil;
}

@end
