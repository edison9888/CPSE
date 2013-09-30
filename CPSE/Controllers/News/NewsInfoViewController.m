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
#import "UIView+BR.h"
#import "UIImage+BR.h"
#import "CommentTableViewCell.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "MBProgressHUD.h"

#define kCellSeparatorLineTag 1
#define kCommentEditorViewHeight 80

@interface NewsInfoViewController ()
{
    UIView *_loadingView;
    
    NSUInteger _id;
    NSString *_newstype;
    NSDictionary *_data;
    NSMutableArray *_comments;
    
    UIScrollView *_scrollView;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UIWebView *_webView;
    
    UIButton *_starButton;
    UITableView *_tableView;
    
    UIView* _commentEditorView;
    UILabel *_commentNameLabel;
    UITextView *_commentContentTextView;
    
    BOOL _keyboardVisible;
    BOOL _viewOnScreen;
}
@end

@implementation NewsInfoViewController

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
    
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.scrollView.bounces = NO;
    _webView.userInteractionEnabled = NO;
    [_scrollView addSubview:_webView];
    
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(9, 0, 180, 44);
    [button setImage:[UIImage imageNamed:@"news-post-button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(212, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon-share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(266, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon-star"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(starAction) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:button];
    _starButton = button;
    
    // post comment
    _commentEditorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), kCommentEditorViewHeight)];
    _commentEditorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _commentEditorView.backgroundColor          = [UIColor colorWithHex:0xefefef];
    _commentEditorView.layer.shadowColor        = [UIColor blackColor].CGColor;
    _commentEditorView.layer.shadowOffset       = CGSizeMake(.0, -.5);
    _commentEditorView.layer.shadowOpacity      = .5f;
    _commentEditorView.layer.borderColor        = [[UIColor colorWithHex:0xeeeeee] CGColor];
    [self.view addSubview:_commentEditorView];
    
    _commentNameLabel = [[UILabel alloc] init];
    _commentNameLabel.backgroundColor = [UIColor clearColor];
    _commentNameLabel.font = [UIFont systemFontOfSize:12];
    _commentNameLabel.numberOfLines = 0;
    _commentNameLabel.textColor = [UIColor colorWithHex:0x333333];
    _commentNameLabel.text = [NSString stringWithFormat:@"%@：", DataMgr.currentAccount.name];
    CGSize size = [_commentNameLabel.text sizeWithFont:_commentNameLabel.font];
    _commentNameLabel.frame = CGRectMake(10, 10, size.width, size.height);
    [_commentEditorView addSubview:_commentNameLabel];
    
    _commentContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10+size.width, 10, 320-size.width-10, kCommentEditorViewHeight)];
    _commentContentTextView.backgroundColor = [UIColor clearColor];
    [_commentEditorView addSubview:_commentContentTextView];
    
    // UIToolBar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.translucent = YES;
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                     style:UIBarButtonItemStyleBordered target:self
                                                                    action:@selector(handleActionBarCancel:)];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"发表评论", @"")
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(handleActionBarPost:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[cancelButton, flexible, postButton]];
    _commentContentTextView.inputAccessoryView = toolBar;
    
    
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
    label.text = @"正在努力加载数据";
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
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=news&newstype=%@&id=%d", _newstype, _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  [_loadingView removeFromSuperview];
                  
                  if ([JSON[@"errno"] intValue] > 0) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                      return;
                  }
                  
                  _data = [JSON[@"data"] objectForKey:[NSString stringWithFormat:@"%d", _id]];
                  [self populateInterface];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [_loadingView removeFromSuperview];
                  DLog(@"error: %@", [error description]);
              }];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=commentsList&id=%d", _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
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
    
    NSString *html = [DataMgr normalizeHtml:_data[@"content"]];
    
    // add site base url prefix
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"src=\"(\\/uploadfile[^\n]+)\""
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    html = [regex stringByReplacingMatchesInString:html
                                           options:0
                                             range:NSMakeRange(0, [html length])
                                      withTemplate:@"src=\"http://images.cps.com.cn$1\""];
    
    // image inline style
    regex = [NSRegularExpression regularExpressionWithPattern:@"<img "
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    html = [regex stringByReplacingMatchesInString:html
                                           options:0
                                             range:NSMakeRange(0, [html length])
                                      withTemplate:@"<img style=\"width:100%;height:auto;\" "];
    
	html =[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\"/></head><body>%@</body></html>", cssPath, html];
    [_webView loadHTMLString:html baseURL:baseURL];
}

- (void)shareAction {
    [UMSocialData defaultData].shareImage = [_webView imageFromSelf];
    [UMSocialData defaultData].extConfig.title = _titleLabel.text;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    
    [UMSocialSnsService presentSnsIconSheetView:self.parentViewController
                                         appKey:kUMengAppKey
                                      shareText:[NSString stringWithFormat:@"%@ %@", _titleLabel.text, _data[@"app_url"]]
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToEmail, UMShareToSms]
                                       delegate:nil];
}

- (void)starAction {
    if ([DataMgr.database intForQuery:@"SELECT COUNT(*) FROM Favorite WHERE id = ?", @(_id)] > 0) {
        [DataMgr.database executeUpdate:@"DELETE FROM Favorite WHERE id = ?", @(_id)];
        [_starButton setImage:[UIImage imageNamed:@"icon-star"] forState:UIControlStateNormal];
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-destar"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"已取消收藏";
        [hud show:YES];
        [hud hide:YES afterDelay:.7];
    }
    else {
        FavoriteType favType = ([_newstype isEqualToString:@"cpse"] ? FavoriteTypeNewsCPSE : FavoriteTypeNewsIndustry);
        [DataMgr.database executeUpdate:@"INSERT INTO Favorite VALUES (?, ?, ?, ?)", @(_id), _titleLabel.text, [NSDate date], @(favType)];
        [_starButton setImage:[[UIImage imageNamed:@"icon-star"] imageTintedWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-star"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"收藏成功";
        [hud show:YES];
        [hud hide:YES afterDelay:.7];
    }
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
- (void)commentAction {
    if (DataMgr.currentAccount == nil) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.title = @"用户登录";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [_commentContentTextView becomeFirstResponder];
}

- (void)handleActionBarCancel:(UIBarButtonItem *)button {
    [_commentContentTextView resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)handleActionBarPost:(UIBarButtonItem *)button {
    if ([_commentContentTextView.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"请输入评论内容"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [_commentContentTextView becomeFirstResponder];
        return;
    }
    
    [_commentContentTextView resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    // post comment
    // this is GET request, so request must encode text in url.
    NSString* encodeedTitle = [DataManager encodeUrl:_data[@"title"]];
    NSString* encodeedContent = [DataManager encodeUrl:_commentContentTextView.text];
    
    NSString *url = [NSString stringWithFormat:@"api.php?action=comments&content=%@&contentid=%d&title=%@&userid=%d&user_name=%@", encodeedContent, _id, encodeedTitle, DataMgr.currentAccount.id, DataMgr.currentAccount.name];
    DLog(@"url=%@", url);
    [AFClient getPath:url
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  DLog(@"post done. %@", JSON);
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else{
                      [_scrollView scrollRectToVisible:CGRectMake(0, CGRectGetMaxY(_tableView.frame)-44, 320, 44) animated:YES];
                      
                      __block NSString *content = _commentContentTextView.text;
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
                          [_tableView beginUpdates];
                          NSDictionary *dict = @{@"username": DataMgr.currentAccount.name, @"content": content};
                          NSUInteger ii[2] = {0, 0};
                          __block NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                          [_comments insertObject:dict atIndex:0];
                          [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                          [_tableView endUpdates];
                          
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
                              CGRect frame = _tableView.frame;
                              frame.size.height = _tableView.contentSize.height;
                              _tableView.frame = frame;
                              _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_tableView.frame));
                              CGFloat height = [self tableView:_tableView heightForRowAtIndexPath:indexPath];
                              [_scrollView scrollRectToVisible:CGRectMake(0, CGRectGetMinY(_tableView.frame), 320, 20 + height) animated:YES];
                          });
                      });
                      
                      _commentContentTextView.text = @"";
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:[NSString stringWithFormat:@"%@", [error description]]
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                  [alert show];
              }];
}

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