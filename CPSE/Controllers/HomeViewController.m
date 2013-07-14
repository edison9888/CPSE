//
//  HomeViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/13/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "BannerViewController.h"
#import "UIColor+BR.h"
#import "UIView+JMNoise.h"

@interface HomeViewController ()
{
    BannerViewController *_banner;
}
@end

@implementation HomeViewController

+ (HomeViewController *)sharedHome {
    static HomeViewController *_sharedHome = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHome = [[HomeViewController alloc] init];
    });
    return _sharedHome;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view applyNoiseWithOpacity:.05];
    
    _banner = [[BannerViewController alloc] init];
    _banner.view.frame = CGRectMake(0, 0, 320, 185);
    [self.view addSubview:_banner.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect buttonRect = CGRectMake(0, 0, 44, 44);
    buttonRect = CGRectInset(buttonRect, 4, 4);
    
    // left view
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-and-text"]];
    leftView.clipsToBounds = NO;
    leftView.layer.shadowColor = [UIColor blackColor].CGColor;
    leftView.layer.shadowOffset = CGSizeMake(0, 1);
    leftView.layer.shadowOpacity = .3;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    // right bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.clipsToBounds = YES;
    rightButton.layer.cornerRadius = 4;
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
    rightView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    rightView.layer.cornerRadius = 5;
    [rightView addSubview:rightButton];
    rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileStatus) name:kAccountChangeNotification object:DataMgr];
    
    // update profile icon status
    UIView *view = self.navigationItem.rightBarButtonItem.customView;
    UIButton *button = (UIButton *)view.subviews[0];
    [button setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
}

- (void)tapRightBarButton {
    DLog(@"tap right button");
}

@end