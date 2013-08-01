//
//  RegisterViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIColor+BR.h"

@interface RegisterViewController ()
{
    UIScrollView *_scrollView;
    UITableView *_tableView;
    NSArray *_data;
    UITextField *_userField, *_emailField, *_realnameField, *_pwdField, *_confirmPwdField, *_companyField, *_departmentField, *_positionField, *_cellField;
}
@end

@implementation RegisterViewController

- (id)init {
    if (self = [super init]) {
        _data = @[@"用  户  名：", @"电子邮箱：", @"真实姓名：", @"登录密码：", @"重复密码：",
                  @"国       家：", @"公司名称：", @"部       门：", @"职       位：", @"手       机：", @"您感兴趣的领域："];
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

- (void)registerAction {
    
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (UITableView *)tableView {
    return _tableView;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.accessoryType = (indexPath.row==5 || indexPath.row==10) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    cell.textLabel.text = _data[indexPath.row];
    CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
    CGRect rect = cell.contentView.frame;
    rect.origin.x = size.width + 10;
    rect.size.width -= size.width + 10;
    
    UITextField *entry = [self createTextEntryWithTag:indexPath.row];
    entry.textColor = [UIColor colorWithHex:0x666666];
    entry.frame = rect;
    [cell.contentView addSubview:entry];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end