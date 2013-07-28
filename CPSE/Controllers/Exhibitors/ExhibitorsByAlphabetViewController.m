//
//  ExhibitorsByAlphabetViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ExhibitorsByAlphabetViewController.h"
#import "UIColor+BR.h"

@interface ExhibitorsByAlphabetViewController ()
{
    UISearchBar *_searchBar;
    UITableView *_table;
    NSDictionary *_data;
    NSArray *_sortedAlphabets;
}
@end

@implementation ExhibitorsByAlphabetViewController

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.placeholder = @"输入全称或首字母查询";
    [self.view addSubview:_searchBar];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44)];
    _table.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _table.backgroundView = nil;
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:@"api.php?action=cclist"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _data = JSON[@"data"];
                  _sortedAlphabets = [[_data allKeys] sortedArrayUsingSelector:@selector(compare:)];
                  DLog(@"%@", _sortedAlphabets);
                  [_table reloadData];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sortedAlphabets count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, view.frame.size.width, 2)];
    line.backgroundColor = [UIColor colorWithHex:0x8e8e8e];
    [view addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1.5, 17, 17)];
    label.backgroundColor = [UIColor colorWithHex:0x8e8e8e];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [_sortedAlphabets objectAtIndex:section];
    label.layer.cornerRadius = 8.5;
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_sortedAlphabets objectAtIndex:section];
    NSArray *array = _data[key];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    NSString *key = [_sortedAlphabets objectAtIndex:indexPath.section];
    NSArray *array = _data[key];
    NSDictionary *dict = array[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchBar resignFirstResponder];
}

@end