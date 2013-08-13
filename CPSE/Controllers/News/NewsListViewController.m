//
//  ExhibitNewsViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsInfoViewController.h"
#import "NewsTableViewCell.h"

@interface NewsListViewController ()
{
    NSString *_newstype;
    NSArray *_data;
}
@end

@implementation NewsListViewController

- (id)initWithType:(NSString *)newstype {
    if (self = [super init]) {
        _newstype = newstype;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=newslist&newstype=%@", _newstype]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _data = JSON[@"data"];
                  [self.tableView reloadData];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary *dict = _data[indexPath.row];
    [cell setData:dict];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = _data[indexPath.row];
    NewsInfoViewController *vc = [[NewsInfoViewController alloc] initWithId:[dict[@"id"] intValue]];
    vc.title = @"新闻内容";
    [self.navigationController pushViewController:vc animated:YES];
}

@end