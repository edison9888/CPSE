//
//  NewsInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NewsInfoViewController.h"
#import "UIColor+BR.h"
#import "CommentTableViewCell.h"

#define kCellSeparatorLineTag 1

@interface NewsInfoViewController ()
{
    NSUInteger _id;
    NSDictionary *_data;
    NSArray *_comments;
    
    UIScrollView *_scrollView;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UIWebView *_webView;
    
    UITableView *_tableView;
}
@end

@implementation NewsInfoViewController

- (id)initWithId:(NSUInteger)id {
    if (self = [super init]) {
        _id = id;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-44)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithHex:0x666666];
    [_scrollView addSubview:_titleLabel];
    
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.scrollView.bounces = NO;
    [_scrollView addSubview:_webView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [_scrollView addSubview:_tableView];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, CGRectGetWidth(self.view.frame), 44)];
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MHTabBarContainerBgPattern"]];
    [self.view addSubview:bar];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 160, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:@"icon-comment"] forState:UIControlStateNormal];
    [button setTitle:@"发表评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(160, 0, 160, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:@"icon-share"] forState:UIControlStateNormal];
    [button setTitle:@"分享新闻" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=news&id=%d", _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _data = [JSON[@"data"] objectForKey:[NSString stringWithFormat:@"%d", _id]];
                  [self populateInterface];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=commentsList&id=%d", _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _comments = JSON[@"data"][@"content"];
                  DLog(@"comments: %@", _comments);
                  [_tableView reloadData];
                  CGRect frame = _tableView.frame;
                  frame.size.height = _tableView.contentSize.height;
                  _tableView.frame = frame;
                  _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_tableView.frame));
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)populateInterface {
    CGRect rect = _scrollView.bounds;
    CGFloat topOffset = 20.f;
    
    NSString *title = _data[@"title"];
    CGSize size = [title sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _titleLabel.frame = CGRectMake(10, topOffset, size.width, size.height);
    _titleLabel.text = title;
    topOffset += size.height + 20;
    
    _webView.frame = CGRectMake(10, topOffset, rect.size.width-20, rect.size.height-topOffset);
    
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"newsStyle" ofType:@"css"];
    //do base url for css
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *html =[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\"/></head><body>%@</body></html>",
                     cssPath , _data[@"content"]];
    [_webView loadHTMLString:html baseURL:baseURL];
}

- (void)commentAction {
    
}

- (void)shareAction {
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    if (fittingSize.width > 300) {
        CGFloat scaleFactor = 300.0 / fittingSize.width;
        frame.size.height = fittingSize.height;// * scaleFactor;
        webView.frame = frame;
        webView.contentScaleFactor = scaleFactor;
    }
    else {
        frame.size.height = fittingSize.height;
        webView.frame = frame;
    }
//    DLog(@"frame is %@", NSStringFromCGRect(frame));
    
    CGRect rect = _tableView.frame;
    rect.origin.y = CGRectGetMaxY(frame) + 10;
    _tableView.frame = rect;
    
    _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_tableView.frame));
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, view.frame.size.width, 2)];
    line.backgroundColor = [UIColor colorWithHex:0x8e8e8e];
    [view addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1.5, 50, 17)];
    label.backgroundColor = [UIColor colorWithHex:0x8e8e8e];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"评论";
    label.layer.cornerRadius = 8.5;
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xcccccc];
        line.tag = kCellSeparatorLineTag;
        [cell addSubview:line];
    }
    
    NSDictionary *dict = _comments[indexPath.row];
    cell.comment = dict;
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    UIView *line = [cell viewWithTag:kCellSeparatorLineTag];
    line.frame = CGRectMake(0, CGRectGetHeight(rect)-1, CGRectGetWidth(rect), 1);
    line.hidden = indexPath.row == [_comments count] - 1;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _comments[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@： %@", dict[@"username"], [DataMgr parseText:dict[@"content"]]];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    DLog(@"row %d, content:%@, height:%f", indexPath.row, content, size.height);
    return MAX(44, size.height + 20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end