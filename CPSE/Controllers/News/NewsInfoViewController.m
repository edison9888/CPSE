//
//  NewsInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "UIColor+BR.h"

@interface NewsInfoViewController ()
{
    NSUInteger _id;
    NSDictionary *_data;
    
    UIScrollView *_scrollView;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UIWebView *_webView;
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
	NSLog(@"%@ : csspath",html);
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
    DLog(@"frame is %@", NSStringFromCGRect(frame));
    
    CGSize contentSize = _scrollView.frame.size;
    contentSize.height = CGRectGetMaxY(frame);
    _scrollView.contentSize = contentSize;
}

@end