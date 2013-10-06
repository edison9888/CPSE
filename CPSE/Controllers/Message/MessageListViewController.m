//
//  NewsInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MessageListViewController.h"
#import "UIColor+BR.h"
#import "UIView+BR.h"
#import "UIImage+BR.h"
#import "CommentTableViewCell.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "MBProgressHUD.h"

#define kCellSeparatorLineTag 1
#define kCommentEditorViewHeight 80

@interface MessageListViewController ()
{
    UIView *_loadingView;
    
    NSUInteger _id;
    NSString *_newstype;
    NSDictionary *_data;
    NSMutableArray *_comments;
    
    UIScrollView *_scrollView;
    UILabel *_titleLabel;
//    UIImageView *_imageView;
//    UIWebView *_webView;
    
    UIButton *_starButton;
    UITableView *_tableView;
    
    UIView* _commentEditorView;
    UILabel *_commentNameLabel;
    UITextView *_commentContentTextView;
    
    BOOL _keyboardVisible;
    BOOL _viewOnScreen;
}
@end

@implementation MessageListViewController

- (id)initWithId:(NSUInteger)id andType:(NSString *)type {
    if (self = [super init]) {
        _id = id;
        _newstype = type;
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
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [_scrollView addSubview:_titleLabel];
//    
//    _imageView = [[UIImageView alloc] init];
//    [_scrollView addSubview:_imageView];
//    
//    _webView = [[UIWebView alloc] init];
//    _webView.backgroundColor = [UIColor clearColor];
//    _webView.delegate = self;
//    _webView.opaque = NO;
//    _webView.scrollView.bounces = NO;
//    _webView.userInteractionEnabled = NO;
//    [_scrollView addSubview:_webView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-320, 0, 320, 0)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.hidden = YES;
    _tableView.separatorColor = [UIColor clearColor];
    [_scrollView addSubview:_tableView];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, CGRectGetWidth(self.view.frame), 44)];
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:bar];

    
    
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

- (void)viewWillAppear:(BOOL)animated {
    _viewOnScreen = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // star or not
    if ([DataMgr.database intForQuery:@"SELECT COUNT(*) FROM Favorite WHERE id = ?", @(_id)])
        [_starButton setImage:[[UIImage imageNamed:@"icon-star"] imageTintedWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=commentsList&id=%d", _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  [_loadingView removeFromSuperview];
                  if ([JSON[@"errno"] intValue] > 0) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                      return;
                  }
                  
                  _comments = [JSON[@"data"][@"content"] mutableCopy];
                  if (isEmpty(_comments))
                      _comments = [NSMutableArray array];
                  //DLog(@"comments: %@", _comments);
                  [_tableView reloadData];
                  CGRect frame = _tableView.frame;
                  frame.size.height = _tableView.contentSize.height;
                  _tableView.frame = frame;
                  _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_tableView.frame));
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [_loadingView removeFromSuperview];
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"加载失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  [alert show];
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    _viewOnScreen = NO;
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - UIWebViewDelegate
#pragma mark -
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
    rect.origin.x = 0;
    _tableView.frame = rect;
    _tableView.hidden = NO;
    
    _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_tableView.frame));
}

#pragma mark - UITableViewDataSource
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, view.frame.size.width, 2)];
    line.backgroundColor = [UIColor colorWithHex:0x8e8e8e];
    [view addSubview:line];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithHex:0x8e8e8e];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Comments", nil);
    label.layer.cornerRadius = 8.5;
    [view addSubview:label];
    
    CGSize size = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake(10, 1.5, size.width+17, 17);

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
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _comments[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@： %@", dict[@"username"], [DataMgr parseText:dict[@"content"]]];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(44, size.height + 20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - post comments
#pragma mark -

- (void)resizeForKeyboard:(NSNotification*)notification {
    if (!_viewOnScreen)
        return;
    
    BOOL up = notification.name == UIKeyboardWillShowNotification;
    
    if (_keyboardVisible == up)
        return;
    
    _keyboardVisible = up;
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationOptions animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
                     animations:^{
                         CGRect frame = _commentEditorView.frame;
                         if (_keyboardVisible)
                             frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(keyboardEndFrame) - CGRectGetHeight(frame);
                         else
                             frame.origin.y = CGRectGetHeight(self.view.frame);
                         _commentEditorView.frame = frame;
                     }
                     completion:NULL];
}

@end