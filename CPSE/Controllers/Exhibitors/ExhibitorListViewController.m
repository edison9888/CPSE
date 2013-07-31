//
//  ExhibitorListViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorListViewController.h"
#import "UIColor+BR.h"
#import "ExhibitorInfoViewController.h"

@interface ExhibitorListViewController ()
{
    UITableView *_table;
    NSString *_action;
    NSArray *_data;
}
@end

@implementation ExhibitorListViewController

- (id)initWithAction:(NSString *)action {
    if (self = [super init]) {
        _action = action;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=%@", _action]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _data = JSON[@"data"];
                  [_table reloadData];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_table deselectRowAtIndexPath:[_table indexPathForSelectedRow] animated:YES];
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
    }
    
    NSDictionary *dict = _data[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _data[indexPath.row];
    ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:[dict[@"id"] intValue]];
    vc.title = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end