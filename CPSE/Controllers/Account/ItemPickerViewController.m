//
//  ItemPickerViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/2/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ItemPickerViewController.h"
#import "UIColor+BR.h"

@interface ItemPickerViewController ()
{
    NSArray *_data;
    BOOL _multiple;
    UITableView *_table;
}
@end

@implementation ItemPickerViewController

// data item like: {name: @"", selected: @NO}
- (id)initWithDataSource:(NSArray *)data multipleSelectable:(BOOL)multiple {
    if (self = [super init]) {
        _data = data;
        _multiple = multiple;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _table = [[UITableView alloc] initWithFrame:self.view.bounds];
    _table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _table.backgroundColor = [UIColor clearColor];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_multiple) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.clipsToBounds = YES;
        rightButton.layer.cornerRadius = 4;
        [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
        [rightButton setImage:[UIImage imageNamed:@"icon-done"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect buttonRect = CGRectMake(0, 0, 44, 44);
        buttonRect = CGRectInset(buttonRect, 7, 7);
        
        UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
        rightView.backgroundColor = [UIColor colorWithHex:0xff0000 alpha:.5];
        rightView.layer.cornerRadius = 5;
        [rightView addSubview:rightButton];
        rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)tapRightBarButton {
    [self.navigationController popViewControllerAnimated:YES];
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
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = _data[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.accessoryType = [dict[@"selected"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_multiple) {
        NSDictionary *dict = _data[indexPath.row];
        BOOL b = [dict[@"selected"] boolValue];
        [dict setValue:@(!b) forKey:@"selected"];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
        for (int i=0; i<[_data count]; i++) {
            NSDictionary *dict = _data[i];
            BOOL b = indexPath.row == i;
            [dict setValue:[NSString stringWithFormat:@"%d", b] forKey:@"selected"];
        }
        [tableView reloadData];
        [self performSelector:@selector(tapLeftBarButton) withObject:nil afterDelay:.5];
    }
}

@end