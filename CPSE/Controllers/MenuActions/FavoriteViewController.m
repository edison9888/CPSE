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
    BOOL _isNews;
    NSMutableArray *_data;
}
@end

@implementation FavoriteViewController

- (id)initWithStyle:(UITableViewStyle)style isNews:(BOOL)isnews {
    if (self = [super initWithStyle:style]) {
        _isNews = isnews;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _data = [NSMutableArray array];
    FMResultSet *rs;
    if (_isNews)
        rs = [DataMgr.database executeQuery:@"SELECT * FROM Favorite WHERE type = ? OR type = ?", @(FavoriteTypeNewsCPSE), @(FavoriteTypeNewsIndustry)];
    else
        rs = [DataMgr.database executeQuery:@"SELECT * FROM Favorite WHERE type = ?", @(FavoriteTypeExhibitor)];
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
    if (favorite.type == FavoriteTypeNewsCPSE || favorite.type == FavoriteTypeNewsIndustry) {
        NSString *type = favorite.type == FavoriteTypeNewsCPSE ? @"cpse" : @"industry";
        NewsInfoViewController *vc = [[NewsInfoViewController alloc] initWithId:favorite.id andType:type];
        vc.title = NSLocalizedString(@"News Content", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:favorite.id];
        vc.title = NSLocalizedString(@"News Content", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
