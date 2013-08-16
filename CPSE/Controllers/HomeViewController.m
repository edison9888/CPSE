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
#import "NewsListViewController.h"
#import "ExhibitorViewController.h"
#import "CalendarViewController.h"
#import "IntroViewController.h"
#import "VenuesViewController.h"
#import "MyConsultViewController.h"
#import "ConsultListViewController.h"

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
                  NSMutableArray *imageArray = [NSMutableArray array];
                  [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                      DLog(@"image=%@, url=%@", obj[@"img"], obj[@"url"]);
                      [imageArray addObject:obj[@"img"]];
                  }];
                  [_banner setImages:imageArray];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
}

#pragma mark - channel actions
- (void)tapChannelNews {
    NewsListViewController *vc1 = [[NewsListViewController alloc] initWithType:@"cpse"];
    NewsListViewController *vc2 = [[NewsListViewController alloc] initWithType:@"industry"];
    vc1.title = @"安博会新闻";
    vc2.title = @"行业新闻";
    
    BaseChannelWithTabsViewController *vc = [[BaseChannelWithTabsViewController alloc] init];
    vc.title = @"新闻";
    vc.viewControllers = @[vc1, vc2];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelExhibitor {
    ExhibitorViewController *vc = [[ExhibitorViewController alloc] init];
    vc.title = @"参展商";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelCalendar {
    CalendarViewController *vc = [[CalendarViewController alloc] init];
    vc.title = @"日程";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelMap {
    VenuesViewController *vc = [[VenuesViewController alloc] init];
    vc.title = @"展位图";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelSubscribe {
    [self tapRightBarButton];
}

- (void)tapChannelNotification {
    
}

- (void)tapChannelFaq {
    MyConsultViewController *vc1 = [[MyConsultViewController alloc] init];
    ConsultListViewController *vc2 = [[ConsultListViewController alloc] init];
    vc1.title = @"我的咨询";
    vc2.title = @"全部咨询";
    
    BaseChannelWithTabsViewController *vc = [[BaseChannelWithTabsViewController alloc] init];
    vc.title = @"咨询";
    vc.viewControllers = @[vc1, vc2];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelIntro {
    IntroViewController *vc = [[IntroViewController alloc] init];
    vc.title = @"简介";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelPicture {
    
}

@end