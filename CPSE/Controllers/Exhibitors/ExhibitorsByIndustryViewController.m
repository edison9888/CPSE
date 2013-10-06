//
//  ExhibitorsByIndustryViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorsByIndustryViewController.h"
#import "UIColor+BR.h"
#import "ExhibitorListViewController.h"

@interface ExhibitorsByIndustryViewController ()
{
    NSArray *_data;
    UIView *_loadingView;
}
@end

@implementation ExhibitorsByIndustryViewController

- (void)loadView {
    [super loadView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // loading view
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(70, 0, 44, CGRectGetHeight(self.view.bounds));
    indicator.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_loadingView addSubview:indicator];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 206, CGRectGetHeight(self.view.bounds))];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = NSLocalizedString(@"Retrieving data", nil);
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [self.view addSubview:_loadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=industry", NSLocalizedString(@"language_type", nil)]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                  [_loadingView removeFromSuperview];
                  
                  _data = JSON[@"data"];
                  [self.tableView reloadData];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
    NSString *query = [NSString stringWithFormat:@"search&type=class&q=%@", dict[@"id"]];
    ExhibitorListViewController *vc = [[ExhibitorListViewController alloc] initWithAction:query];
    vc.title = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end