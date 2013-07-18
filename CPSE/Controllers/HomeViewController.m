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
#import "ChannelIconButton.h"
#import "NewsChannelViewController.h"
#import "ExhibitorChannelViewController.h"

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
    [self.view addSubview:_banner.view];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CGFloat h = (CGRectGetHeight(rect) - 44 - kBannerHeight - 20) / 3.0;
    
    // 1st row
    ChannelIconButton *button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(5, kBannerHeight+5, 100, h)];
    [button setTitle:@"新闻" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-news"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelNews) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(110, kBannerHeight+5, 100, h)];
    [button setTitle:@"展商" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-exhibitor"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelExhibitor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(215, kBannerHeight+5, 100, h)];
    [button setTitle:@"日程" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-calendar"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 2nd row
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(5, kBannerHeight+10+h, 100, h)];
    [button setTitle:@"展位图" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-map"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(110, kBannerHeight+10+h, 100, h)];
    [button setTitle:@"参观申请" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-subscribe"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(215, kBannerHeight+10+h, 100, h)];
    [button setTitle:@"消息" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-notification"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 3rd row
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(5, kBannerHeight+15+2*h, 100, h)];
    [button setTitle:@"咨询" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-faq"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelFaq) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(110, kBannerHeight+15+2*h, 100, h)];
    [button setTitle:@"简介" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-intro"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelIntro) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(215, kBannerHeight+15+2*h, 100, h)];
    [button setTitle:@"图片" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-picture"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:@"api.php?action=adlist&count=5"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  NSArray *data = [JSON valueForKeyPath:@"data"];
                  [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                      DLog(@"image=%@, url=%@", obj[@"img"], obj[@"url"]);
                  }];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect buttonRect = CGRectMake(0, 0, 44, 44);
    buttonRect = CGRectInset(buttonRect, 7, 7);
    
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

#pragma mark - channel actions
- (void)tapChannelNews {
    NewsChannelViewController *vc = [[NewsChannelViewController alloc] init];
    vc.title = @"新闻";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelExhibitor {
    ExhibitorChannelViewController *vc = [[ExhibitorChannelViewController alloc] init];
    vc.title = @"参展商";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelCalendar {
    
}

- (void)tapChannelMap {
    
}

- (void)tapChannelSubscribe {
    
}

- (void)tapChannelNotification {
    
}

- (void)tapChannelFaq {
    
}

- (void)tapChannelIntro {
    
}

- (void)tapChannelPicture {
    
}

@end