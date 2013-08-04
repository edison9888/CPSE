//
//  LoginViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+BR.h"
#import "RegisterViewController.h"
#import "CustomIconButton.h"
#import "AccountInfoViewController.h"

@interface LoginViewController ()
{
    UIScrollView *_scrollView;
    UITableView *_tableView;
    CustomIconButton *_rememberButton;
    
    UITextField *_userField, *_pwdField;
}
@end

@implementation LoginViewController

- (id)init {
    if (self = [super init]) {
        _rememberButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _rememberButton.imageOriginX = 0;
        _rememberButton.titleOriginX = 30;
        _rememberButton.selected = YES;
        _rememberButton.frame = CGRectMake(10, 0, 200, 44);
        _rememberButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rememberButton addTarget:self action:@selector(toggleRememberButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rememberButton setImage:[UIImage imageNamed:@"check-button-unchecked"] forState:UIControlStateNormal];
        [_rememberButton setImage:[UIImage imageNamed:@"check-button-checked"] forState:UIControlStateSelected];
        [_rememberButton setTitle:@"记住用户名和密码" forState:UIControlStateNormal];
        [_rememberButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    CGRect rect = self.view.bounds;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    CGRect frame = CGRectMake(10, 20, CGRectGetWidth(rect)-20, 220);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [_scrollView addSubview:_tableView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, CGRectGetWidth(rect), 2)];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash-line"]];
    [_scrollView addSubview:line];
    
    UIImage *buttonBg = [UIImage imageNamed:@"red-button-bg"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    button.frame = CGRectMake(CGRectGetWidth(rect)/2-buttonBg.size.width/2, 280, buttonBg.size.width, buttonBg.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [button setTitle:@"登   录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetMaxY(button.frame)+10);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)toggleRememberButton:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)loginAction {
    if ([_userField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [_userField becomeFirstResponder];
        return;
    }
    if ([_pwdField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [_pwdField becomeFirstResponder];
        return;
    }

    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=login&username=%@&pwd=%@&type=user", _userField.text, _pwdField.text]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else {
                      DataMgr.currentAccount = [[Account alloc] initWithAttributes:JSON[@"data"]];
//                      [self.navigationController popViewControllerAnimated:YES];
                      AccountInfoViewController* acccountInfo = [[AccountInfoViewController alloc] initWithAccount:DataMgr.currentAccount];
                      UINavigationController *navController = self.navigationController;
                      [navController popViewControllerAnimated:NO];
                      [navController pushViewController:acccountInfo
                                                           animated:YES];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (UITableView *)tableView {
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect rect = cell.contentView.frame;
        rect.origin.x = 75;
        rect.size.width -= 75;
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"用户名：";
                UITextField *entry = [self createTextEntryWithTag:indexPath.row];
                entry.textColor = [UIColor colorWithHex:0x666666];
                entry.frame = rect;
                [cell.contentView addSubview:entry];
                _userField = entry;
            }
                break;
            case 1: {
                cell.textLabel.text = @"密    码：";
                UITextField *entry = [self createTextEntryWithTag:indexPath.row];
                entry.secureTextEntry = YES;
                entry.textColor = [UIColor colorWithHex:0x666666];
                entry.frame = rect;
                [cell.contentView addSubview:entry];
                _pwdField = entry;
            }
                break;
            case 2: {
                [cell.contentView addSubview:_rememberButton];
            }
            break;
        }
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = @"新用户登记";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }
    else {
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        vc.title = @"用户注册";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end