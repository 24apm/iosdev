//
//  XibView.m
//  WhatTheWord
//
//  Created by 15inch on 5/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "XibView.h"
#import "NSBundle+BundleUtil.h"

@implementation XibView

- (id)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self; 
}

//- (void)_setup {
//    self.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height);
//    
//    NSString *nibName = NSStringFromClass([self class]);
//    NSArray *nibObjects = nil;
//    Class UINibClass = NSClassFromString(@"UINib");
//    if (UINibClass && [UINibClass respondsToSelector:@selector(nibWithNibName:bundle:)]) {
//        UINib *nib = [UINibClass nibWithNibName:nibName bundle:nil];
//        nibObjects = [nib instantiateWithOwner:self options:nil];
//    } else {
//        nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
//    }
//    
//    UIView *xibView = [nibObjects objectAtIndex:0];
//    self.backgroundColor = [UIColor clearColor];
//    self.autoresizingMask = xibView.autoresizingMask;
//    
//    if (self.bounds.size.width <= 0.f && self.bounds.size.height <= 0.f) {
//        // xib's frame override parent's frame
//        self.frame = xibView.frame;
//    } else {
//        // parent frame overrides xib's frame
//        xibView.frame = self.frame;
//    }
//    [self addSubview:xibView];
//    self.userInteractionEnabled = xibView.userInteractionEnabled;
//}

- (void)_setup {
    if(!self.loaderView) {
        self.loaderView = [[UIView alloc] init];
        [self addSubview:self.loaderView];
        self.loaderView.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height);

        NSString *nibName = NSStringFromClass([self class]);
        NSArray *nibObjects = nil;
        Class UINibClass = NSClassFromString(@"UINib");
        if (UINibClass && [UINibClass respondsToSelector:@selector(nibWithNibName:bundle:)]) {
            UINib *nib;
            if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
                nib = [UINibClass nibWithNibName:nibName bundle:nil];
            } else {
                nib = [UINibClass nibWithNibName:nibName bundle:[NSBundle myLibraryResourcesBundle]];
            }
            nibObjects = [nib instantiateWithOwner:self options:nil];
        } else {
            nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        }
        
        UIView *xibView = [nibObjects objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = self.loaderView.autoresizingMask;
        
        if (self.bounds.size.width <= 0.f && self.bounds.size.height <= 0.f) {
            // xib's frame override parent's frame
            self.loaderView.frame = xibView.frame;
        } else {
            // parent frame overrides xib's frame
            xibView.frame = self.loaderView.frame;
        }
        [self.loaderView addSubview:xibView];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.loaderView.frame.size.width, self.loaderView.frame.size.height);
        self.loaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizingMask = xibView.autoresizingMask;
        self.userInteractionEnabled = xibView.userInteractionEnabled;
    }
}


@end
