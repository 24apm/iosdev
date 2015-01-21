//
//  ButtonBase.m
//  BaseLibrary
//
//  Created by MacCoder on 11/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ButtonBase.h"
#import "ConfigManager.h"

@implementation ButtonBase

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName
                                           size:self.titleLabel.font.pointSize * [ConfigManager instance].ipadScale];

}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];
}

@end
