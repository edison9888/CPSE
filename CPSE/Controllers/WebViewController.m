//
//  WebViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *webView;
    NSString *_url;
}
@end

@implementation WebViewController

- (id)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)loadView {
    webView = [[UIWebView alloc] init];
    webView.delegate = self;
    self.view = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    if ([theWebView respondsToSelector:@selector(scrollView)]) {
        CGSize contentSize = theWebView.scrollView.contentSize;
        CGSize viewSize = self.view.bounds.size;
        
        float rw = viewSize.width / contentSize.width;
        
        theWebView.scrollView.minimumZoomScale = rw;
        theWebView.scrollView.maximumZoomScale = rw;
        theWebView.scrollView.zoomScale = rw;
        
        theWebView.scalesPageToFit = YES;
    }
}

@end