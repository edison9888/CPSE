//
//  BaseChannelViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BaseChannelViewController.h"
#import "UIColor+BR.h"
#import "UIView+JMNoise.h"
#import "LoginViewController.h"
#import "AccountInfoViewController.h"
#import "KxMenu.h"
#import "HomeViewController.h"
#import "FavoriteViewController.h"
#import "BaseChannelWithTabsViewController.h"
#import "ZXingWidgetController.h"
#import "QRCodeReader.h"

@interface BaseChannelViewController ()

@end

@implementation BaseChannelViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view applyNoiseWithOpacity:.05];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;

    CGRect buttonRect = CGRectMake(0, 0, 44, 44);
    buttonRect = CGRectInset(buttonRect, 7, 7);
    
    // left bar button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(tapLeftBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftView = [[UIView alloc] initWithFrame:buttonRect];
    leftView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    leftView.layer.cornerRadius = 5;
    [leftView addSubview:leftButton];
    leftButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    
    // right bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.clipsToBounds = YES;
    rightButton.layer.cornerRadius = 4;
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"icon-menu-list"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
    rightView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    rightView.layer.cornerRadius = 5;
    [rightView addSubview:rightButton];
    rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    // title
    NSString *title = self.title;
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:20]];
    if (size.width > 222 && size.width < 330) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 222, 44)];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = title;
        self.navigationItem.titleView = titleLabel;
    }
    else {
        self.title = title;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileStatus) name:kAccountChangeNotification object:DataMgr];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    NSMutableArray *menuItems = [NSMutableArray arrayWithObjects:[KxMenuItem menuItem:@"首页" image:[UIImage imageNamed:@"menu-icon-home"] target:self action:@selector(menuHomeAction)],
                                 [KxMenuItem menuItem:@"个人中心" image:[UIImage imageNamed:@"menu-icon-user"] target:self action:@selector(menuUserAction)],
                                 [KxMenuItem menuItem:@"我的收藏" image:[UIImage imageNamed:@"menu-icon-star"] target:self action:@selector(menuFavoriteAction)],
                                 [KxMenuItem menuItem:@"扫一扫" image:[UIImage imageNamed:@"menu-icon-scan"] target:self action:@selector(menuScanAction)],
                                 [KxMenuItem menuItem:@"退出登录" image:[UIImage imageNamed:@"menu-icon-logout"] target:self action:@selector(menuLogoutAction)],
                                 nil];
    
    // exclue home menu item if it is at home view
    if ([self isKindOfClass:[HomeViewController class]]) {
        [menuItems removeObjectAtIndex:0];
    }
    
    if (isEmpty(DataMgr.currentAccount)) {
        [menuItems removeLastObject];
    }
    
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(320-44, -44, 44, 44) menuItems:menuItems];
}

- (void)menuHomeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)menuUserAction {
    if (DataMgr.currentAccount == nil) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.title = @"用户登录";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        AccountInfoViewController *vc = [[AccountInfoViewController alloc]
                                         initWithAccount:DataMgr.currentAccount];
        vc.title = @"用户中心";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)menuFavoriteAction {
    FavoriteViewController *vc1 = [[FavoriteViewController alloc] initWithStyle:UITableViewStylePlain andType:FavoriteTypeNews];
    FavoriteViewController *vc2 = [[FavoriteViewController alloc] initWithStyle:UITableViewStylePlain andType:FavoriteTypeExhibitor];
    
    vc1.title = @"新闻";
    vc2.title = @"展商";
    
    BaseChannelWithTabsViewController *vc = [[BaseChannelWithTabsViewController alloc] init];
    vc.title = @"我的收藏";
    vc.viewControllers = @[vc1, vc2];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)menuScanAction {
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    widController.readers = readers;
    
    [self presentViewController:widController animated:YES completion:nil];
}

- (void)menuLogoutAction {
    DataMgr.currentAccount = nil;
    [UserDefaults setValue:nil forKey:kUCLoginUsername];
    [UserDefaults setValue:nil forKey:kUCLoginPassword];
    [UserDefaults synchronize];
}

- (void)updateProfileStatus {
}

#pragma mark - rotation control
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - ZXingDelegate
#pragma mark -
- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 DLog(@"%@", result);
                             }];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

@end