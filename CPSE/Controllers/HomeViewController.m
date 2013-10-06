//
//  HomeViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/13/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
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
#import "LoginViewController.h"
#import "ExhibitorInfoViewController.h"
#import "WebViewController.h"
#import "AccountInfoViewController.h"
#import "MessageListViewController.h"

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
    _banner.delegate = self;
    [self.view addSubview:_banner.view];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CGFloat h = (CGRectGetHeight(rect) - 44 - kBannerHeight - 20) / 3.0;
    
    // 1st row
    ChannelIconButton *button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(5, kBannerHeight+5, 100, h)];
    [button setTitle:NSLocalizedString(@"News", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-news"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelNews) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(110, kBannerHeight+5, 100, h)];
    [button setTitle:NSLocalizedString(@"Exhibitors", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-exhibitor"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelExhibitor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(215, kBannerHeight+5, 100, h)];
    [button setTitle:NSLocalizedString(@"Schedule", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-calendar"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 2nd row
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(5, kBannerHeight+10+h, 100, h)];
    [button setTitle:NSLocalizedString(@"Floor Plan", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-map"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(110, kBannerHeight+10+h, 100, h)];
    [button setTitle:NSLocalizedString(@"Visit Application", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-subscribe"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(215, kBannerHeight+10+h, 100, h)];
    [button setTitle:NSLocalizedString(@"Messages", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-notification"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 3rd row
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(5, kBannerHeight+15+2*h, 100, h)];
    [button setTitle:NSLocalizedString(@"Consult", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-faq"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelFaq) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(110, kBannerHeight+15+2*h, 100, h)];
    [button setTitle:NSLocalizedString(@"Introduction", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button-icon-intro"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapChannelIntro) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[ChannelIconButton alloc] initWithFrame:CGRectMake(215, kBannerHeight+15+2*h, 100, h)];
    [button setTitle:NSLocalizedString(@"Pictures", nil) forState:UIControlStateNormal];
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
                  NSMutableArray *array = [NSMutableArray array];
                  [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                      DLog(@"image=%@, url=%@", obj[@"img"], obj[@"url"]);
                      AdUriModel *adUri = [[AdUriModel alloc] initWithAttributes:obj];
                      [array addObject:adUri];
                  }];
                  _banner.dataSource = array;
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
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

#pragma mark - BannerViewControllerDelegate
#pragma mark -
- (void)clickWithAdUri:(AdUriModel *)adUri {
    if (adUri.uriType == AdUriTypeExhibitorUrl) {
        WebViewController *vc = [[WebViewController alloc] initWithUrl:adUri.linkUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (adUri.uriType == AdUriTypeExhibitorId) {
        ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:[adUri.linkId intValue]];
        vc.title = NSLocalizedString(@"Exhibitor Info", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - channel actions
#pragma mark -
- (void)tapChannelNews {
    NewsListViewController *vc1 = [[NewsListViewController alloc] initWithType:@"cpse"];
    NewsListViewController *vc2 = [[NewsListViewController alloc] initWithType:@"industry"];
    vc1.title = NSLocalizedString(@"CPSE News",  nil);
    vc2.title = NSLocalizedString(@"Industry News", nil);
    
    BaseChannelWithTabsViewController *vc = [[BaseChannelWithTabsViewController alloc] init];
    vc.title = NSLocalizedString(@"News", nil);
    vc.viewControllers = @[vc2, vc1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelExhibitor {
    ExhibitorViewController *vc = [[ExhibitorViewController alloc] init];
    vc.title = NSLocalizedString(@"Exhibitors", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelCalendar {
    CalendarViewController *vc = [[CalendarViewController alloc] init];
    vc.title = NSLocalizedString(@"Schedule", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelMap {
    VenuesViewController *vc = [[VenuesViewController alloc] init];
    vc.title = NSLocalizedString(@"Floor Plan", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelSubscribe {
    if (DataMgr.currentAccount == nil) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.title = NSLocalizedString(@"User Login", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        AccountInfoViewController *vc = [[AccountInfoViewController alloc]
                                         initWithAccount:DataMgr.currentAccount];
        vc.title = NSLocalizedString(@"Personal Center", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tapChannelNotification {
    MessageListViewController *vc = [[MessageListViewController alloc] init];
    vc.title = NSLocalizedString(@"Messages", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelFaq {
    if (DataMgr.currentAccount == nil) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.title = NSLocalizedString(@"User Login", nil);
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    MyConsultViewController *vc1 = [[MyConsultViewController alloc] init];
    ConsultListViewController *vc2 = [[ConsultListViewController alloc] init];
    vc1.title = NSLocalizedString(@"My Enquiry", nil);
    vc2.title = NSLocalizedString(@"All Enquiry", nil);
    
    BaseChannelWithTabsViewController *vc = [[BaseChannelWithTabsViewController alloc] init];
    vc.title = NSLocalizedString(@"Consult", nil);
    vc.viewControllers = @[vc1, vc2];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelIntro {
    IntroViewController *vc = [[IntroViewController alloc] init];
    vc.title = NSLocalizedString(@"Introduction", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapChannelPicture {
    NSString *msg = @"\"图片\"功能将在下个版本开通";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end