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
    NSString *_action;
    NSArray *_data;
    UIView *_loadingView;
}
@end

@implementation ExhibitorListViewController

- (id)initWithAction:(NSString *)action {
    if (self = [super init]) {
        _action = action;
        
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(70, 0, 44, 44);
        [_loadingView addSubview:indicator];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 220, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.text = NSLocalizedString(@"Retrieving data", nil);
        [_loadingView addSubview:label];
        [indicator startAnimating];
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
    
    if (!isEmpty(_action))
        [self.view addSubview:_loadingView];
    
    if (!isEmpty(_action)) {
        [AFClient getPath:[NSString stringWithFormat:@"api.php?action=%@", _action]
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                      [_loadingView removeFromSuperview];
                      
                      _data = JSON[@"data"];
                      [_table reloadData];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"error: %@", [error description]);
                  }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_table deselectRowAtIndexPath:[_table indexPathForSelectedRow] animated:YES];
}

- (void)setData:(NSArray *)data {
    if (isEmpty(data))
        _data = @[];
    else
        _data = data;
    [_table reloadData];
}

#pragma mark - UITableViewDataSource
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    NSDictionary *dict = _data[indexPath.row];
    cell.selectionStyle = [dict[@"id"] intValue] ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    cell.textLabel.text = dict[@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _data[indexPath.row];
    if ([dict[@"id"] intValue]) {
        ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:[dict[@"id"] intValue]];
        vc.title = dict[@"name"];

        if (self.navigationController)
            [self.navigationController pushViewController:vc animated:YES];
        else
            [self.owner.navigationController pushViewController:vc animated:YES];
    }
}

@end