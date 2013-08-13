//
//  ExhibitorsByAreaViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorsByAreaViewController.h"
#import "UIColor+BR.h"
#import "ExhibitorListViewController.h"

@interface ExhibitorsByAreaViewController ()
{
    NSArray *_data;
}
@end

@implementation ExhibitorsByAreaViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:@"api.php?action=arealist"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", dict[@"region_name"], dict[@"count"]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _data[indexPath.row];
    NSString *query = [NSString stringWithFormat:@"search&type=area&areaid=%@", dict[@"areaid"]];
    ExhibitorListViewController *vc = [[ExhibitorListViewController alloc] initWithAction:query];
    vc.title = dict[@"region_name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end