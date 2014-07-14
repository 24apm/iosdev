//
//  VisitorView.h
//  Weed
//
//  Created by MacCoder on 7/13/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "XibView.h"
#import "VisitorData.h"

extern NSString *const VisitorViewRefreshNotification;

@interface VisitorView : XibView

@property (strong, nonatomic) VisitorData *data;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;

- (void)setupWithData:(VisitorData *)data;

@end
