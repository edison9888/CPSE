//
//  FavoriteViewController.m
//  CPSE
//
//  Created by Lei Perry on 9/23/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "FavoriteViewController.h"
#import "Favorite.h"
#import "NewsInfoViewController.h"
#import "ExhibitorInfoViewController.h"

@interface FavoriteViewController ()
{
    FavoriteType _type;
    NSMutableArray *_data;
}
@end

@implementation FavoriteViewController

- (id)initWithStyle:(UITableViewStyle)style andType:(FavoriteType)type {
    if (self = [super initWithStyle:style]) {
        _type = type;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _data = [NSMutableArray array];
    FMResultSet *rs = [DataMgr.database executeQuery:@"SELECT * FROM Favorite WHERE type = ?", @(_type)];
    while ([rs next]) {
        Favorite *favorite = [[Favorite alloc] initWithId:[rs intForColumn:@"id"] title:[rs stringForColumn:@"title"] type:[rs intForColumn:@"type"]];
        [_data addObject:favorite];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    
    Favorite *favorite = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = favorite.title;
    
    return cell;
}

#pragma mark - Table view delegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Favorite *favorite = [_data objectAtIndex:indexPath.row];
    if (_type == FavoriteTypeNews) {
        NewsInfoViewController *vc = [[NewsInfoViewController alloc] initWithId:favorite.id andType:(favorite.id > 10000 ? @"industry" : @"cpse")];
        vc.title = @"新闻内容";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:favorite.id];
        vc.title = @"展商详情";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
