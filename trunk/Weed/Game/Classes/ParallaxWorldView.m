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

@interface ParallaxWorldView()

@property (strong, nonatomic) NSMutableArray *parallaxViews;
@property (strong, nonatomic) ParallaxBackgroundView *backgroundView;
@property (strong, nonatomic) ParallaxForegroundView *foregroundView;

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
    self.editModeMessage.hidden = YES;
    self.exitEditModebutton.hidden = YES;
    
    [[UserData instance] addObserver:self forKeyPath:@"coin" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [[RealEstateManager instance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateCoinToHud:) name:kHouseViewCollectedNotification object:nil];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"coin"]) {
        id newValue = [object valueForKeyPath:keyPath];
        self.coinLabel.text = [NSString stringWithFormat:@"%d", [newValue integerValue]];
    } else if ([keyPath isEqual:@"state"]) {
        RealEstateManagerState newValue = [[object valueForKeyPath:keyPath] integerValue];
        self.headerView.hidden = YES;
        self.exitEditModebutton.hidden = YES;
        self.editModeMessage.hidden = YES;
        
        switch (newValue) {
            case RealEstateManagerStateNormal:
                self.headerView.hidden = NO;
                break;
            case RealEstateManagerStateEdit: {
                self.exitEditModebutton.hidden = NO;
                self.editModeMessage.hidden = NO;
                RenterData *renterData = [RealEstateManager instance].currentRenterData.renterData;
                HouseView *firstEmptyHouse = [self.foregroundView firstEmptyHouseUnder:renterData.count];
                [self.foregroundView.scrollView scrollRectToVisible:CGRectMake(firstEmptyHouse.center.x - self.width * 0.5f, self.foregroundView.scrollView.y, self.foregroundView.scrollView.width, self.foregroundView.scrollView.height) animated:YES];
                
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
