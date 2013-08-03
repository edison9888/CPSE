//
//  ExhibitorInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "UIColor+BR.h"
#import <QuartzCore/QuartzCore.h>

@interface AccountInfoViewController ()
{
    NSInteger _userId;
    NSString* _userName;
//    NSDictionary *_data;
    
//    UIScrollView *_scrollView;
//    UILabel *_infoLabel;
//    UILabel *_descLabel;
    
    UIWebView *_webView;
}
@end

@implementation AccountInfoViewController

- (id)initWithId:(NSInteger)userId userName:(NSString*)userName {
    if (self = [super init]) {
        _userId = userId;
        _userName = userName;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit =YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate =self;

//    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
    
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"accountInfo" ofType:@"html" inDirectory:@"CPSE/Controllers/Account"];
    NSString* htmlFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"accountInfo.html" ofType:nil];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",htmlString);
    [_webView loadHTMLString:htmlString baseURL:nil];
    
//    _infoLabel = [[UILabel alloc] init];
//    _infoLabel.backgroundColor = [UIColor clearColor];
//    _infoLabel.font = [UIFont systemFontOfSize:13];
//    _infoLabel.numberOfLines = 0;
//    _infoLabel.textColor = [UIColor colorWithHex:0x666666];
//    [_scrollView addSubview:_infoLabel];
//    
//    _descLabel = [[UILabel alloc] init];
//    _descLabel.backgroundColor = [UIColor clearColor];
//    _descLabel.font = [UIFont systemFontOfSize:12];
//    _descLabel.numberOfLines = 0;
//    _descLabel.textColor = [UIColor colorWithHex:0x666666];
//    [_scrollView addSubview:_descLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start load.");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish load.");
    
    CGSize layerSize = self.view.bounds.size;
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f) {
        UIGraphicsBeginImageContextWithOptions(layerSize, NO, 2.0f);
    } else {
        UIGraphicsBeginImageContext(layerSize);
    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage,nil,NULL,NULL);

}

@end