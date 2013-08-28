//
//  ConsultListViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/15/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultListViewController.h"
#import "UIColor+BR.h"
#import "ConsultTableViewCell.h"
#import "ConsultModel.h"
#import "ConsultSetModel.h"

@interface ConsultListViewController ()
{
    UIView *_loadingView;
    NSMutableArray *_consultSets;
}
@end

@implementation ConsultListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    [AFClient getPath:@"api.php?action=consultlist"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else {
                      _consultSets = [NSMutableArray array];
                      
                      NSArray *allFaqs = JSON[@"data"];
                      for (NSDictionary *faq in allFaqs) {
                          ConsultSetModel *set = [[ConsultSetModel alloc] initWithId:[faq[@"id"] intValue] andAttributes:faq];
                          [_consultSets addObject:set];
                      }
                      [self.tableView reloadData];
                      [_loadingView removeFromSuperview];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

#pragma mark - UITableViewDataSource
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_consultSets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ConsultTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ConsultSetModel *set = _consultSets[indexPath.row];
    cell.consultSet = set;
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsultSetModel *set = _consultSets[indexPath.row];
    return [ConsultTableViewCell heightForConsultSet:set];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end