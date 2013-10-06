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
    NSUInteger _lastId;
}
@end

@implementation NewsListViewController

- (id)initWithType:(NSString *)newstype {
    if (self = [super init]) {
        _newstype = newstype;
        _lastId = NSUIntegerMax;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self createHeaderView];
    [self refreshView:YES];
}

- (void)mergeData {
    for (int i=0; i<[_adlist count]; i++) {
        int idx = 3*(i+1)-1;
        if (idx > [_data count])
            break;
        [_data insertObject:_adlist[i] atIndex:idx];
    }
    
    // update interface
    [self.tableView reloadData];
    [self setFooterView];
    
    [self finishReloadingData];
    
    // no need any more
    if (_refreshHeaderView) {
        [_refreshHeaderView removeFromSuperview];
        _refreshHeaderView = nil;
    }
}


#pragma mark - methods for creating and removing the header view
#pragma mark -
- (void)createHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    CGRect rect = self.view.bounds;
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -CGRectGetHeight(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
    _refreshHeaderView.delegate = self;
    
	[self.tableView addSubview:_refreshHeaderView];
}

- (void)removeHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

- (void)setFooterView {
    if (_lastId == 0)
        return;
    
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f, height, self.tableView.frame.size.width, self.view.bounds.size.height);
    }
    else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
}

- (void)removeFooterView {
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

// force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}

#pragma mark - data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self refreshView:NO];
    }
    else if (aRefreshPos == EGORefreshFooter) {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:1.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark - method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
    }
    
    [self setFooterView];
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark - EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
}

- (void)refreshView:(BOOL)clean {
    // show header view
    self.tableView.contentOffset = CGPointMake(0, -REFRESH_HEADER_HEIGHT-5);
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    
    if (clean) {
        [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=newslist&newstype=%@", NSLocalizedString(@"language_type", nil), _newstype]
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                      //DLog(@"news %@", JSON);
                      _data = [JSON[@"data"] mutableCopy];
                      if ([_data count] > 0) {
                          NSDictionary *dict = [_data lastObject];
                          _lastId = [dict[@"id"] intValue];
                      }
                      if (![_newstype isEqualToString:kNewsTypeCPSE] || !isEmpty(_adlist))
                          [self mergeData];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"error: %@", [error description]);
                  }];
        
        // ad
        if ([_newstype isEqualToString:kNewsTypeCPSE]) {
            [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=adlist&option=newslist", NSLocalizedString(@"language_type", nil)]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                          _adlist = JSON[@"data"];
                          //DLog(@"%@", _adlist);
                          if (!isEmpty(_data))
                              [self mergeData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          DLog(@"error: %@", [error description]);
                      }];
        }
    }
}

- (void)getNextPageView {
    NSString *url = [NSString stringWithFormat:@"api.php?language_type=%@&action=newslist&newstype=%@&pull=0&id=%d", NSLocalizedString(@"language_type", nil), _newstype, _lastId];
    DLog(@"next page url: %@", url);
    
    [AFClient getPath:url
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  NSArray *items = JSON[@"data"];
                  if ([items count] > 0) {
                      NSDictionary *dict = [items lastObject];
                      _lastId = [dict[@"id"] intValue];
                      
                      [_data addObjectsFromArray:items];
                      
                      // update interface
                      [self.tableView reloadData];
                      [self setFooterView];
                      
                      [self finishReloadingData];
                  }
                  else {
                      _lastId = 0;
                      
                      [self removeFooterView];
                      [self finishReloadingData];
                      
                      [UIView beginAnimations:nil context:NULL];
                      [UIView setAnimationDuration:0.2];
                      self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                      [UIView commitAnimations];
                  }
                  DLog(@"last id %d", _lastId);
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
    return 70;
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
            vc.title = NSLocalizedString(@"News Content", nil);
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