//
//  RegisterViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIColor+BR.h"
#import "ItemPickerViewController.h"
#import "AccountInfoViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()
{
    UIScrollView *_scrollView;
    UITableView *_tableView;
    NSArray *_data;
    UITextField *_userField, *_emailField, *_realnameField, *_pwdField, *_confirmPwdField, *_countryField, *_companyField, *_departmentField, *_positionField, *_cellField, *_areasField;
    NSArray *_dataCountries, *_dataAreas;
    
    UITextField *_invalidEntry;
}
@end

@implementation RegisterViewController

- (id)init {
    if (self = [super init]) {
        _data = @[@"用  户  名：", @"电子邮箱：", @"真实姓名：", @"登录密码：", @"重复密码：",
                  @"国       家：", @"公司名称：", @"部       门：", @"职       位：", @"手       机：", @"您感兴趣的领域："];
        _dataCountries = @[[NSMutableDictionary dictionaryWithObjectsAndKeys:@"中国大陆", @"name", @"0", @"selected", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"澳      门", @"name", @"0", @"selected", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"香      港", @"name", @"0", @"selected", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"台      湾", @"name", @"0", @"selected", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"其他国家及地区", @"name", @"0", @"selected", nil]];
        
        _dataAreas = @[[NSMutableDictionary dictionaryWithObjectsAndKeys:@"视频监控", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"防盗报警", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"楼宇对讲", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"一卡通", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"智能分析", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"智能家具", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"公共广播", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"视频会议", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"安防线缆", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"传输设备", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"显示设备", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"存储设备", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"安防综合平台", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"安防系统集成", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"芯片级解决方案", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"智能交通", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"警用设备", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"消防设备", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"安检排爆", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"元器件", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"五金器材", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"媒体/协会", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"公安部门", @"name", @"0", @"selected", nil],
                       [NSMutableDictionary dictionaryWithObjectsAndKeys:@"研究院", @"name", @"0", @"selected", nil]];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    CGRect rect = self.view.bounds;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    CGRect frame = CGRectMake(10, 20, CGRectGetWidth(rect)-20, [_data count]*44+20);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [_scrollView addSubview:_tableView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame)+20, CGRectGetWidth(rect), 2)];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash-line"]];
    [_scrollView addSubview:line];
    
    UIImage *buttonBg = [UIImage imageNamed:@"red-button-bg"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    button.frame = CGRectMake(CGRectGetWidth(rect)/2-buttonBg.size.width/2, CGRectGetMaxY(_tableView.frame)+40, buttonBg.size.width, buttonBg.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [button setTitle:@"完成登记" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetMaxY(button.frame)+10);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    DLog(@"selected=%d", indexPath.row);
    if (indexPath.row > 0) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        [_tableView reloadData];
    }
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (UITableView *)tableView {
    return _tableView;
}

- (NSString *)getSelectedCountry {
    for (int i=0; i<[_dataCountries count]; i++) {
        NSDictionary *dict = _dataCountries[i];
        if ([dict[@"selected"] boolValue])
            return dict[@"name"];
    }
    return @"";
}

- (NSString *)getInterestedAreas {
    NSMutableArray *areas = [NSMutableArray array];
    for (int i=0; i<[_dataAreas count]; i++) {
        NSDictionary *dict = _dataAreas[i];
        if ([dict[@"selected"] boolValue])
            [areas addObject:dict[@"name"]];
    }
    return [areas componentsJoinedByString:@"/"];
}

- (void)registerAction {
    NSString *message;
    UITextField *entry;
    for (int i=0; i<[self.textEntries count]; i++) {
        entry = self.textEntries[i];
        if (i==0 && [entry.text length]==0) {
            message = @"请输入用户名";
            break;
        }
        if (i==1) {
            if ([entry.text length]==0) {
                message = @"请输入电子邮箱";
                break;
            }
            else {
                NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if ([test evaluateWithObject:entry.text] == NO) {
                    message = @"请输入正确的电子邮箱";
                    break;
                }
            }
        }
        if (i==2 && [entry.text length]==0) {
            message = @"请输入真实姓名";
            break;
        }
        if (i==3 && [entry.text length]==0) {
            message = @"请输入密码";
            break;
        }
        if (i==4) {
            if ([entry.text length]==0) {
                message = @"请输入重复密码";
                break;
            }
            else {
                UITextField *lastEntry = self.textEntries[i-1];
                if (![lastEntry.text isEqualToString:entry.text]) {
                    message = @"重复密码与密码不一致";
                    break;
                }
            }
        }
        if (i==5 && [entry.text length]==0) {
            message = @"请选择国家";
            break;
        }
        if (i==6 && [entry.text length]==0) {
            message = @"请输入公司名称";
            break;
        }
        if (i==7 && [entry.text length]==0) {
            message = @"请输入部门";
            break;
        }
        if (i==8 && [entry.text length]==0) {
            message = @"请输入职位";
            break;
        }
        if (i==9) {
            if ([entry.text length]==0) {
                message = @"请输入手机号";
                break;
            }
            else {
                NSString *regex = @"^(1)\\d{10}$";
                NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if ([test evaluateWithObject:entry.text] == NO) {
                    message = @"请输入正确的手机号";
                    break;
                }
            }
        }
        if (i==10 && [entry.text length]==0) {
            message = @"请选择您感兴趣的领域";
            break;
        }
    }
    
    if (entry != nil && !isEmpty(message)) {
        _invalidEntry = entry;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];        
        return;
    }
    
    NSString *q = [NSString stringWithFormat:@"api.php?action=reg&username=%@&email=%@&truename=%@&password=%@&repwd=%@&country=%@&cp_name=%@&mobile=%@&job=%@&productRange=%@&department=%@",
                   [_userField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _emailField.text,
                   [_realnameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _pwdField.text, _confirmPwdField.text,
                   [_countryField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                   [_companyField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _cellField.text,
                   [_positionField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                   [_areasField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                   [_departmentField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    DLog(@"q=%@", q);
    [AFClient getPath:q
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else {
                      DLog(@"reg response: %@", JSON[@"data"]);
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你已注册成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                      DataMgr.currentAccount = [[Account alloc] initWithAttributes:JSON[@"data"]];
                      
                      // goto account info page
                      AccountInfoViewController *vc = [[AccountInfoViewController alloc] initWithAccount:DataMgr.currentAccount];
                      vc.title = @"用户中心";
                      [self.navigationController pushViewController:vc animated:YES];
                      
                      NSMutableArray *vcs = [NSMutableArray array];
                      for (UIViewController *vc in self.navigationController.viewControllers) {
                          if (![vc isKindOfClass:[LoginViewController class]] && ![vc isKindOfClass:[RegisterViewController class]])
                              [vcs addObject:vc];
                      }
                      self.navigationController.viewControllers = vcs;
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_invalidEntry becomeFirstResponder];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSUInteger ii[2] = {0, _invalidEntry.tag-1};
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
        rect = [self.tableView convertRect:rect toView:self.scrollView];
        CGFloat visibleHeight = CGRectGetHeight(self.view.frame) - self.scrollView.contentInset.bottom;
        CGPoint offset = CGPointMake(0, MAX(0, CGRectGetMidY(rect)-visibleHeight/2-44));
        [self.scrollView setContentOffset:offset animated:YES];    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    }

    cell.textLabel.text = _data[indexPath.row];

    CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
    CGRect rect = cell.contentView.frame;
    rect.origin.x = size.width + 10;
    rect.size.width -= size.width + 15;
    
    UITextField *entry = [self createTextEntryWithTag:indexPath.row+1];
    entry.textColor = [UIColor colorWithHex:0x666666];
    entry.frame = rect;
    [cell.contentView addSubview:entry];
    
    if (indexPath.row == 3 || indexPath.row == 4)
        entry.secureTextEntry = YES;
    
    if (indexPath.row == 5 || indexPath.row == 10) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        entry.userInteractionEnabled = NO;
        entry.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.row == 5)
            entry.text = [self getSelectedCountry];
        if (indexPath.row == 10)
            entry.text = [self getInterestedAreas];
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 0)
        _userField = entry;
    else if (indexPath.row == 1)
        _emailField = entry;
    else if (indexPath.row == 2)
        _realnameField = entry;
    else if (indexPath.row == 3)
        _pwdField = entry;
    else if (indexPath.row == 4)
        _confirmPwdField = entry;
    else if (indexPath.row == 5)
        _countryField = entry;
    else if (indexPath.row == 6)
        _companyField = entry;
    else if (indexPath.row == 7)
        _departmentField = entry;
    else if (indexPath.row == 8)
        _positionField = entry;
    else if (indexPath.row == 9)
        _cellField = entry;
    else if (indexPath.row == 10)
        _areasField = entry;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        ItemPickerViewController *vc = [[ItemPickerViewController alloc] initWithDataSource:_dataCountries multipleSelectable:NO];
        vc.title = @"选择国家";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 10) {
        ItemPickerViewController *vc = [[ItemPickerViewController alloc] initWithDataSource:_dataAreas multipleSelectable:YES];
        vc.title = @"选择您感兴趣的领域";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end