//
//  LabelBase.m
//  BaseLibrary
//
//  Created by MacCoder on 11/18/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "LabelBase.h"
#import "ConfigManager.h"

@implementation LabelBase

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
    self.font = [UIFont fontWithName:self.font.fontName
                                           size:self.font.pointSize * [ConfigManager instance].ipadScale];
    
}

@end

