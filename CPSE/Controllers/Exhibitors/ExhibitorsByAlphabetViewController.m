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
#import "ExhibitorInfoViewController.h"

#define kCellSeparatorLineTag 1

@interface ExhibitorsByAlphabetViewController ()
{
    UITableView *_table;
    NSDictionary *_data;
    NSArray *_sortedAlphabets;
    UIView *_loadingView;
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
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 00, 320, self.view.bounds.size.height)];
    _table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _table.backgroundView = nil;
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorColor = [UIColor clearColor];
    _table.hidden = YES;
    [self.view addSubview:_table];
    
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
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=cclist", NSLocalizedString(@"language_type", nil)]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _table.hidden = NO;
                  [_loadingView removeFromSuperview];
                  
                  _data = JSON[@"data"];
                  _sortedAlphabets = [[_data allKeys] sortedArrayUsingSelector:@selector(compare:)];
//                  DLog(@"%@", _sortedAlphabets);
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
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sortedAlphabets;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sortedAlphabets[section];
}

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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xcccccc];
        line.tag = kCellSeparatorLineTag;
        [cell addSubview:line];
    }
    
    NSString *key = [_sortedAlphabets objectAtIndex:indexPath.section];
    NSArray *array = _data[key];
    NSDictionary *dict = array[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    
    [cell viewWithTag:kCellSeparatorLineTag].hidden = indexPath.row == [array count] - 1;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [_sortedAlphabets objectAtIndex:indexPath.section];
    NSArray *array = _data[key];
    NSDictionary *dict = array[indexPath.row];
    ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:[dict[@"id"] intValue]];
    vc.title = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end