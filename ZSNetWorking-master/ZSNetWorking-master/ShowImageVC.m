//
//  ShowImageVC.m
//  ZSNetWorking-master
//
//  Created by safiri on 2018/8/16.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ShowImageVC.h"

@interface ShowImageVC ()

@end

@implementation ShowImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    CGFloat imageW = self.image.size.width;
    CGFloat imageH = self.image.size.height;
    scrollView.contentSize = CGSizeMake(imageW, imageH);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    imageView.image = self.image;
    [scrollView addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
