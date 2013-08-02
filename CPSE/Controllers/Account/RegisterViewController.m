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

@interface RegisterViewController ()
{
    UIScrollView *_scrollView;
    UITableView *_tableView;
    NSArray *_data;
    UITextField *_userField, *_emailField, *_realnameField, *_pwdField, *_confirmPwdField, *_companyField, *_departmentField, *_positionField, *_cellField;
    NSArray *_dataCountries, *_dataAreas;
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
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    DLog(@"selected=%d", indexPath.row);
    if (indexPath.row > 0) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        [_tableView reloadData];
    }
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
    return [areas componentsJoinedByString:@", "];
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
    
    UITextField *entry = [self createTextEntryWithTag:indexPath.row];
    entry.textColor = [UIColor colorWithHex:0x666666];
    entry.frame = rect;
    [cell.contentView addSubview:entry];
    
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