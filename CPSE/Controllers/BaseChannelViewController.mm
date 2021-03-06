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
#import "AccountInfoViewController.h"
#import "ExhibitorInfoViewController.h"

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
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        self.title = title;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileStatus) name:kAccountChangeNotification object:DataMgr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINavigationBar *navigationBar = [self.navigationController navigationBar];
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg"] forBarMetrics:UIBarMetricsDefault];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    NSMutableArray *items = [NSMutableArray array];
    if (![self isKindOfClass:[HomeViewController class]]) {
        [items addObject:[KxMenuItem menuItem:NSLocalizedString(@"Home", nil) image:[UIImage imageNamed:@"menu-icon-home"] target:self action:@selector(menuHomeAction)]];
    }
    
    if (![self isKindOfClass:[AccountInfoViewController class]]) {
        [items addObject:[KxMenuItem menuItem:NSLocalizedString(@"Personal Center", nil) image:[UIImage imageNamed:@"menu-icon-user"] target:self action:@selector(menuUserAction)]];
    }
    
    if (![self.title isEqualToString:NSLocalizedString(@"My Favorites", nil)]) {
        [items addObject:[KxMenuItem menuItem:NSLocalizedString(@"My Favorites", nil) image:[UIImage imageNamed:@"menu-icon-star"] target:self action:@selector(menuFavoriteAction)]];
    }
    
    [items addObject:[KxMenuItem menuItem:NSLocalizedString(@"Sweep", nil) image:[UIImage imageNamed:@"menu-icon-scan"] target:self action:@selector(menuScanAction)]];
    
    if (!isEmpty(DataMgr.currentAccount)) {
        [items addObject:[KxMenuItem menuItem:NSLocalizedString(@"Log out", nil) image:[UIImage imageNamed:@"menu-icon-logout"] target:self action:@selector(menuLogoutAction)]];
    }
    
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(320-44, -44, 44, 44) menuItems:items];
}

- (void)menuHomeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)menuUserAction {
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

- (void)menuFavoriteAction {
    FavoriteViewController *vc1 = [[FavoriteViewController alloc] initWithStyle:UITableViewStylePlain isNews:YES];
    FavoriteViewController *vc2 = [[FavoriteViewController alloc] initWithStyle:UITableViewStylePlain isNews:NO];
    
    vc1.title = NSLocalizedString(@"News", nil);
    vc2.title = NSLocalizedString(@"Exhibitors", nil);
    
    BaseChannelWithTabsViewController *vc = [[BaseChannelWithTabsViewController alloc] init];
    vc.title = NSLocalizedString(@"My Favorites", nil);
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
    
    if ([self isKindOfClass:[AccountInfoViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
                                 NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"e:\\d{4}"
                                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                                          error:nil];
                                 NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
                                 if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                                     NSString *id = [result substringWithRange:NSMakeRange(rangeOfFirstMatch.location+2, rangeOfFirstMatch.length-2)];
                                     ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:[id intValue]];
                                     vc.title = NSLocalizedString(@"Exhibitor Info", nil);
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }
                                 else {
                                     MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                                     [self.view addSubview:hud];
                                     hud.mode = MBProgressHUDModeText;
                                     hud.labelText = NSLocalizedString(@"Invalid exhibitor QR-code", nil);
                                     [hud show:YES];
                                     [hud hide:YES afterDelay:.7];
                                 }
                             }];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

@end