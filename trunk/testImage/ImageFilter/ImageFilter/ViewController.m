//
//  ViewController.m
//  ImageFilter
//
//  Created by MacCoder on 12/20/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import "PictureView.h"

@interface ViewController ()
@property (strong, nonatomic) PictureView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[PictureView alloc]init];
    [self.view addSubview:self.imageView];
   // self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
