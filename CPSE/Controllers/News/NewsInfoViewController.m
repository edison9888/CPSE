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
#define kOFFSET_FOR_KEYBOARD 170.0

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
    UIView *_bar;
    
    UIView* _commentEditorView;
    UILabel *_commentNameLabel;
    UITextView *_commentContentTextView;
    UIButton *_commentButton;
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-320, 0, 320, 0)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.hidden = YES;
    _tableView.separatorColor = [UIColor clearColor];
    [_scrollView addSubview:_tableView];
    
    _bar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, CGRectGetWidth(self.view.frame), 44)];
    _bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _bar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MHTabBarContainerBgPattern"]];
    _bar.layer.zPosition=99;
    [self.view addSubview:_bar];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 160, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:@"icon-comment"] forState:UIControlStateNormal];
    [button setTitle:@"发表评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(160, 0, 160, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:@"icon-share"] forState:UIControlStateNormal];
    [button setTitle:@"分享新闻" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:button];
    
    
    // post comment
    _commentEditorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 120)];
    _commentEditorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _commentEditorView.backgroundColor          = [UIColor colorWithHex:0xefefef];
    _commentEditorView.layer.shadowRadius       = 2.0;
    _commentEditorView.layer.shadowColor        = [UIColor blackColor].CGColor;
    _commentEditorView.layer.shadowOffset       = CGSizeMake(.0, -.5);
    _commentEditorView.layer.shadowOpacity      = .5f;
    _commentEditorView.layer.borderColor        = [[UIColor colorWithHex:0xeeeeee] CGColor];
    _commentEditorView.layer.shouldRasterize    =YES;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_commentEditorView.bounds];
    _commentEditorView.layer.shadowPath = path.CGPath;
    [self.view addSubview:_commentEditorView];
    
    _commentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50,50)];
    _commentNameLabel.backgroundColor = [UIColor clearColor];
    _commentNameLabel.font = [UIFont systemFontOfSize:12];
    _commentNameLabel.numberOfLines = 0;
    _commentNameLabel.textColor = [UIColor colorWithHex:0x333333];
    _commentNameLabel.text = DataMgr.currentAccount.name;
    CGSize size = [_commentNameLabel.text sizeWithFont:_commentNameLabel.font
                                     constrainedToSize:CGSizeMake(50, 50)
                                         lineBreakMode:NSLineBreakByWordWrapping];
    _commentNameLabel.frame = CGRectMake(10, 10, size.width, size.height);
    [_commentEditorView addSubview:_commentNameLabel];
    
    _commentContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(70, 10, 240,60)];
    _commentContentTextView.backgroundColor=[UIColor whiteColor];
    [_commentEditorView addSubview:_commentContentTextView];
    
    //
    UIImage *buttonBg = [UIImage imageNamed:@"red-button-bg"];
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _commentButton.frame = CGRectMake(CGRectGetWidth(_commentEditorView.frame)/2-buttonBg.size.width/2, 80,
                                     buttonBg.size.width, buttonBg.size.height);
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _commentButton.titleLabel.textColor = [UIColor whiteColor];
    [_commentButton setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [_commentButton setTitle:@"发表留言" forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(postCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [_commentEditorView addSubview:_commentButton];
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

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    //    CommentEditorViewController* c =[[CommentEditorViewController alloc]
    //                                     initBottomPos:_bar.frame.origin.y];
    //    [self.view addSubview:c.view];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _commentEditorView.center =
                         CGPointMake(_commentEditorView.center.x,
                                     _bar.frame.origin.y-CGRectGetHeight(_commentEditorView.frame)/2);
                     }
                     completion:^(BOOL b){
                         [_commentContentTextView becomeFirstResponder];
                     }];
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
    rect.origin.x = 0;
    _tableView.frame = rect;
    _tableView.hidden = NO;
    
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

#pragma mark - post comments
- (void)postCommentAction {
    DLog(@"post comment");
    
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
    
    _commentButton.enabled =NO;
    // this is GET request, so request must encode text in url.
    NSString* encodeedTitle =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL,
                                                                          (__bridge CFStringRef) _data[@"title"],
                                                                          NULL,
                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                          kCFStringEncodingUTF8));
    NSString* encodeedContent =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL,
                                                                          (__bridge CFStringRef) _commentContentTextView.text,
                                                                          NULL,
                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                          kCFStringEncodingUTF8));
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=comments&content=%@&contentid=%d&title=%@",encodeedContent, _id, encodeedTitle]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  DLog(@"post done.");
                  [UIView animateWithDuration:0.2
                                        delay:0
                                      options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                                   animations:^{
                                       _commentEditorView.center =
                                       CGPointMake(_commentEditorView.center.x,
                                                   [UIScreen mainScreen].bounds.size.height);
                                   }
                                   completion:^(BOOL b){
                                       [_commentContentTextView resignFirstResponder];
                                       _commentContentTextView.text = @"";
                                   }];
                  _commentButton.enabled =YES;
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
                  
                  UIAlertView *alert = [[UIAlertView alloc]
                                        initWithTitle:@""
                                        message:[NSString stringWithFormat:@"%@", [error description] ]
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
                  [alert show];
                  _commentButton.enabled =YES;
              }];
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    [self setViewMovedUp:YES];
}

-(void)keyboardWillHide {
    [self setViewMovedUp:NO];
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2]; // if you want to slide up the view
    
    CGPoint p= _commentEditorView.center;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        p.y -= kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        p.y += kOFFSET_FOR_KEYBOARD;
    }
    _commentEditorView.center =p;
    
    [UIView commitAnimations];}

@end