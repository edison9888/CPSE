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
#import "ExhibitorInfoViewController.h"
#import "WebViewController.h"

#define kNewsTypeCPSE @"cpse"
#define kNewsTypeIndustry @"industry"

@interface NewsListViewController ()
{
    NSString *_newstype;
    NSMutableArray *_data;
    NSArray *_adlist;
    UIView *_loadingView;
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
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(70, 0, 44, 44);
    [_loadingView addSubview:indicator];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 220, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"正在努力加载数据";
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [self.tableView addSubview:_loadingView];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=newslist&newstype=%@", _newstype]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _data = [JSON[@"data"] mutableCopy];
//                  DLog(@"%@", _data);
                  if (![_newstype isEqualToString:kNewsTypeCPSE] || !isEmpty(_adlist))
                      [self mergeData];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
    
    // ad
    if ([_newstype isEqualToString:kNewsTypeCPSE]) {
        [AFClient getPath:@"api.php?action=adlist&option=newslist"
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                      _adlist = JSON[@"data"];
                      DLog(@"%@", _adlist);
                      if (!isEmpty(_data))
                          [self mergeData];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"error: %@", [error description]);
                  }];
    }
}

- (void)mergeData {
    for (int i=0; i<[_adlist count]; i++) {
        int idx = 3*(i+1)-1;
        if (idx > [_data count])
            break;
        [_data insertObject:_adlist[i] atIndex:idx];
    }
    [self.tableView reloadData];
    
    [_loadingView removeFromSuperview];
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
    if ([dict[@"jump"] boolValue]) {
        WebViewController *vc = [[WebViewController alloc] initWithUrl:dict[@"url"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        NSString *type = dict[@"type"];
        if ([type isEqualToString:@"html"]) {
            NewsInfoViewController *vc = [[NewsInfoViewController alloc] initWithId:[dict[@"id"] intValue] andType:_newstype];
            vc.title = @"新闻内容";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            ExhibitorInfoViewController *vc = [[ExhibitorInfoViewController alloc] initWithId:[dict[@"url"] intValue]];
            vc.title = @"展商信息";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end