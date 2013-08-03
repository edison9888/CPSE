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
    [rightButton setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
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
    [self updateProfileStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    if (DataMgr.currentAccount == nil) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.title = @"用户登录";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        AccountInfoViewController *vc = [[AccountInfoViewController alloc] initWithId:DataMgr.currentAccount.id userName:DataMgr.currentAccount.name];
        vc.title = @"用户中心";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)updateProfileStatus {
    if (self.navigationItem.rightBarButtonItem) {
        UIView *view = self.navigationItem.rightBarButtonItem.customView;
        UIButton *button = (UIButton *)view.subviews[0];
        if (DataMgr.currentAccount != nil)
            [button setImage:[UIImage imageNamed:@"icon-profile-online"] forState:UIControlStateNormal];
        else
            [button setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
    }
}

@end