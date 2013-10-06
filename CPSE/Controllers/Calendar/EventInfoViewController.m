//
//  EventInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "EventInfoViewController.h"
#import "UIImage+BR.h"
#import "UIColor+BR.h"

@interface EventInfoViewController ()
{
    NSUInteger _id;
    UIScrollView *_scrollView;
    
    UIView *_loadingView;
}
@end

@implementation EventInfoViewController

- (id)initWithId:(NSUInteger)id {
    if (self = [super init]) {
        _id = id;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=event&id=%d", NSLocalizedString(@"language_type", nil), _id]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  [_loadingView removeFromSuperview];
                  
                  [self populateInterface];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)populateInterface {
    float topOffset = 30;
    
    UIImage *buttonBg = [[UIImage imageNamed:@"red-button-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    UIImage *selectedButtonBg = [buttonBg imageTintedWithColor:[UIColor colorWithHex:0xee2222]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, topOffset, 120, buttonBg.size.height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:buttonBg forState:UIControlStateNormal];
    [button setBackgroundImage:selectedButtonBg forState:UIControlStateHighlighted];
    [button setTitle:@"预约" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleDetailPanel:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
}

@end