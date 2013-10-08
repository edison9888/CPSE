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
        _rememberButton.selected = [UserDefaults boolForKey:kUCLoginRememberMe];
        _rememberButton.frame = CGRectMake(10, 0, 280, 44);
        _rememberButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rememberButton addTarget:self action:@selector(toggleRememberButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rememberButton setImage:[UIImage imageNamed:@"check-button-unchecked"] forState:UIControlStateNormal];
        [_rememberButton setImage:[UIImage imageNamed:@"check-button-checked"] forState:UIControlStateSelected];
        [_rememberButton setTitle:NSLocalizedString(@"Remember username and password", nil) forState:UIControlStateNormal];
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
    [button setTitle:NSLocalizedString(@"login_submit", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetMaxY(button.frame)+10);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
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
    [UserDefaults setBool:button.selected forKey:kUCLoginRememberMe];
    [UserDefaults synchronize];
}

- (void)loginAction {
    if ([_userField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter user name", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [_userField becomeFirstResponder];
        return;
    }
    if ([_pwdField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter password", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [_pwdField becomeFirstResponder];
        return;
    }

    [DataMgr loginWithUsername:_userField.text password:_pwdField.text gotoAccountPageFrom:self];
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
        
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = NSLocalizedString(@"login_user", nil);
                CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                CGRect rect = cell.contentView.frame;
                rect.origin.x = size.width + 15;
                rect.size.width -= size.width + 15;

                UITextField *entry = [self createTextEntryWithTag:indexPath.row];
                entry.textColor = [UIColor colorWithHex:0x666666];
                entry.frame = rect;
                [cell.contentView addSubview:entry];
                _userField = entry;
            }
                break;
            case 1: {
                cell.textLabel.text = NSLocalizedString(@"login_password", nil);
                CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
                CGRect rect = cell.contentView.frame;
                rect.origin.x = size.width + 15;
                rect.size.width -= size.width + 15;

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
        cell.textLabel.text = NSLocalizedString(@"Register as new user", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }
    else {
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        vc.title = NSLocalizedString(@"User Registration", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end