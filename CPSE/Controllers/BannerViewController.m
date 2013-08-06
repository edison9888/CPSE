//
//  BannerViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/14/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BannerViewController.h"
#import "UIColor+BR.h"
#import "UIImageView+AFNetworking.h"

@interface BannerViewController ()
{
    UIView *_loadingView;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation BannerViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kBannerHeight)];
    
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _loadingView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
    [self.view addSubview:_loadingView];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    indicator.color = [UIColor darkGrayColor];
    [_loadingView addSubview:indicator];
    [indicator startAnimating];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.center = CGPointMake(160, 170);
    [self.view addSubview:_pageControl];
}

- (void)setImages:(NSArray *)urls {
    for (int i=0; i<[urls count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, kBannerHeight)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        [imageView setImageWithURL:[NSURL URLWithString:urls[i]]];
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(320*[urls count], kBannerHeight);
    _pageControl.numberOfPages = [urls count];
    [_loadingView removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

@end